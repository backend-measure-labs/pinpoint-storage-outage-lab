#!/usr/bin/env bash
# 장애 주입. run-lab.sh 가 source 해서 쓴다. 호출 전에 NS · KUBECONFIG 가 정해져 있어야 한다.
#
# 원천에 확실하다고 남은 장애는 셋이다: 컬렉터 다운 · HBase 락 타임아웃 · HBase 다운.
# 컬렉터 다운은 두 모습으로 넣는다. 프로세스가 없으면 연결이 거부되고, 응답하지 않으면 연결은 살아 있는 채 읽지 않는다.
# 에이전트의 채널 쓰기 버퍼(32MB)가 찰 수 있는 것은 뒤쪽뿐이다.

NETSHOOT=nicolaka/netshoot:v0.13
# 컬렉터의 HBase 요청 · 작업 타임아웃은 10초다 (pinpoint-collector hbase-root.properties).
# 응답을 그보다 늦게 돌려주면 리전 서버는 살아 있는 채로 쓰기마다 타임아웃이 난다. 컬렉터가 보는 락 타임아웃과 같다.
HBASE_DELAY=${HBASE_DELAY:-15s}

_container() {
  docker ps -q --filter "label=io.kubernetes.pod.namespace=$NS" --filter "label=io.kubernetes.container.name=$1" | head -1
}

_collector_ip() {
  kubectl -n "$NS" get pods -l app=pinpoint-collector -o jsonpath='{.items[0].status.podIP}'
}

# HBase 파드에서 컬렉터로 가는 패킷만 늦춘다. ZooKeeper 세션은 건드리지 않아 리전 서버가 죽지 않는다.
# (컨테이너 일시정지는 ZooKeeper 세션 상한 40초를 넘기면 리전 서버를 종료시켜 다운이 된다.)
hbase_lock_timeout_on() {
  local ip
  ip=$(_collector_ip)
  docker run --rm --net "container:$(_container hbase)" --cap-add NET_ADMIN "$NETSHOOT" sh -c "
    tc qdisc add dev eth0 root handle 1: prio &&
    tc qdisc add dev eth0 parent 1:3 handle 30: netem delay $HBASE_DELAY limit 1000000 &&
    tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst $ip/32 flowid 1:3" >/dev/null
}

hbase_lock_timeout_off() {
  docker run --rm --net "container:$(_container hbase)" --cap-add NET_ADMIN "$NETSHOOT" \
    tc qdisc del dev eth0 root >/dev/null 2>&1 || true
}

# 리전 서버 프로세스를 강제 종료한다 (마스터 · ZooKeeper 는 그대로)
hbase_down_on() {
  # 패턴을 [r] 로 쓰는 것은 이 셸 자신의 명령줄이 걸리지 않게 하려는 것이다
  kubectl -n "$NS" exec deploy/pinpoint-hbase -c hbase -- sh -c '
    for p in /proc/[0-9]*; do
      if tr "\0" " " < $p/cmdline 2>/dev/null | grep -q "[r]egionserver.HRegionServer"; then kill -9 ${p#/proc/}; fi
    done'
}

# 리전 서버를 다시 띄우고, 마스터가 리전을 다시 배치해 쓰기가 되는 데까지 기다린다
hbase_down_off() {
  kubectl -n "$NS" exec deploy/pinpoint-hbase -c hbase -- /opt/hbase/hbase-1.2.6/bin/hbase-daemon.sh start regionserver >/dev/null
  local out deadline=$((SECONDS + ${HBASE_RECOVER_TIMEOUT:-600}))
  while true; do
    if [ "$SECONDS" -ge "$deadline" ]; then
      echo "HBase 가 ${HBASE_RECOVER_TIMEOUT:-600}초 안에 쓰기를 받지 않는다" >&2
      return 1
    fi
    # pipefail 아래에서 grep -q 를 파이프 끝에 두면 앞 명령의 SIGPIPE 가 결과를 뒤집는다. 출력을 받아 비교한다.
    out=$(kubectl -n "$NS" exec deploy/pinpoint-hbase -c hbase -- sh -c \
      'echo "put \"AgentInfo\", \"lab-probe\", \"Info:x\", \"1\"" | timeout 60 /opt/hbase/hbase-1.2.6/bin/hbase shell 2>&1' 2>/dev/null || true)
    [[ "$out" == *"0 row(s) in"* ]] && break
    sleep 5
  done
}

# 컨테이너를 일시정지한다. 커널은 TCP 연결을 계속 받지만 컬렉터 프로세스는 읽지 않는다.
collector_unresponsive_on() { docker pause "$(_container collector)" >/dev/null; }
collector_unresponsive_off() {
  docker ps -aq --filter "label=io.kubernetes.pod.namespace=$NS" --filter label=io.kubernetes.container.name=collector \
    --filter status=paused | xargs -r docker unpause >/dev/null
}

collector_down_on() { kubectl -n "$NS" scale deploy/pinpoint-collector --replicas=0 >/dev/null; }
collector_down_off() { kubectl -n "$NS" scale deploy/pinpoint-collector --replicas=1 >/dev/null; }
