#!/usr/bin/env bash
# 한 회차: 핀포인트 서버 · 앱 구성 → 장애 단계 진행 → 수집 → 철거.
#
#   scripts/run-lab.sh
#   OUTAGE=900 scripts/run-lab.sh   # 단계 길이(초)는 환경 변수로 바꾼다
#
# 결과는 reports/run-<시각>/ 에 남는다. 분석은 scripts/analyze.py.
set -euo pipefail
cd "$(dirname "$0")/.."

NS=pinpoint-lab
LAB_CONTEXT=${LAB_CONTEXT:-rancher-desktop}
LAB_NODE=${LAB_NODE:-lima-rancher-desktop}
# 단계 길이의 근거 (리드미 「조건」)
#   정상 300초: 통계 전송 묶음(5초 수집 × 6) 30초의 10회분
#   장애 420초: 에이전트의 가장 긴 타이머 not-ready-timeout 300초 + keepalive 판정(30+60초) + 여유
#   재기동 240초: gRPC 재연결 대기 상한 120초의 두 바퀴
#   복구 180초: 재연결 대기 상한 120초 + 안정 60초
NORMAL=${NORMAL:-300}
OUTAGE=${OUTAGE:-420}
RECOVER=${RECOVER:-180}
RESTART=${RESTART:-240}
RUN_ID=${RUN_ID:-$(date +%Y%m%d-%H%M%S)}
OUT=reports/run-$RUN_ID
mkdir -p "$OUT"

# 로컬 클러스터 하나만 담은 kubeconfig 를 쓴다. 기본 컨텍스트가 다른 클러스터여도 닿지 않게 한다.
lab_kubeconfig=$(mktemp)
kubectl config view --minify --flatten --context "$LAB_CONTEXT" > "$lab_kubeconfig"
export KUBECONFIG=$lab_kubeconfig
node=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
if [ "$node" != "$LAB_NODE" ]; then
  echo "로컬 노드가 아니다: '$node' (기대: $LAB_NODE). 멈춘다." >&2
  rm -f "$KUBECONFIG"
  exit 1
fi

# shellcheck source=scripts/faults.sh
. scripts/faults.sh

PIDS=()
cleanup() {
  for p in "${PIDS[@]:-}"; do kill "$p" 2>/dev/null || true; done
  hbase_lock_timeout_off
  collector_unresponsive_off
  # 지우지 않고 0개로 줄인다. 네임스페이스 정리는 사람이 한다 (리드미 부록)
  if [ "${KEEP:-0}" != 1 ]; then
    scale_all 0
  fi
  rm -f "$KUBECONFIG"
}
trap cleanup EXIT

scale_all() {
  k get deploy -o name 2>/dev/null | xargs -r kubectl -n "$NS" scale --replicas="$1" >/dev/null 2>&1 || true
}

# 프로브 · 로그는 VM 시계, 단계 표시는 호스트 시계다. 둘의 차이를 남겨 분석에서 맞춘다.
record_clock() {
  local h1 v h2
  h1=$(now_ms)
  v=$(docker exec "$(docker ps -q --filter "label=io.kubernetes.pod.namespace=$NS" --filter label=io.kubernetes.container.name=hbase | head -1)" date +%s%N)
  h2=$(now_ms)
  echo "$(( (h1 + h2) / 2 )),$(( v / 1000000 ))" >> "$OUT/clock.csv"
}

now_ms() { perl -MTime::HiRes=time -e 'printf "%d\n", time*1000'; }
log() { echo "[$(date +%H:%M:%S)] $*"; }
mark() { echo "$(now_ms),$1" >> "$OUT/events.csv"; log "단계: $1"; }
k() { kubectl -n "$NS" "$@"; }

app_pod() {
  k get pods -l app=outage-lab-app --sort-by=.metadata.creationTimestamp \
    -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.deletionTimestamp}{"\n"}{end}' \
    | awk 'NF==1 {p=$1} END {print p}'
}

# 새 앱 파드의 표준 출력(프로브 · 에이전트 로그)을 처음부터 따라간다
follow_app() {
  local pod=""
  until [ -n "$pod" ] && [ "$(k get pod "$pod" -o jsonpath='{.status.phase}' 2>/dev/null)" = Running ]; do
    sleep 1
    pod=$(app_pod)
  done
  # 함수 k 를 백그라운드로 띄우면 $! 가 서브셸이라 kill 해도 kubectl 이 남는다
  kubectl -n "$NS" logs -f "$pod" > "$OUT/app-$pod.log" 2>&1 &
  PIDS+=($!)
  echo "$(now_ms),$pod" >> "$OUT/pods.csv"
  log "앱 파드: $pod"
}

# 컬렉터는 단계 중에 내렸다 올리므로 파드가 바뀐다. 새 파드가 생기면 로그를 따라간다.
follow_collectors() {
  local seen=" "
  # 이 함수는 서브셸로 돈다. 띄운 로그 추적은 cleanup 의 PIDS 에 닿지 않아 여기서 함께 끝낸다.
  trap 'kill $(jobs -p) 2>/dev/null; exit 0' TERM
  while true; do
    for pod in $(k get pods -l app=pinpoint-collector -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
      case "$seen" in *" $pod "*) continue ;; esac
      if [ "$(k get pod "$pod" -o jsonpath='{.status.phase}' 2>/dev/null)" = Running ]; then
        kubectl -n "$NS" logs -f "$pod" > "$OUT/collector-$pod.log" 2>&1 &
        seen="$seen$pod "
      fi
    done
    sleep 3
  done
}

wait_app_ready() { k rollout status deploy/outage-lab-app --timeout=600s >/dev/null; }

# 단계가 끝날 때 앱의 네이티브 메모리 구역과 스레드 이름별 개수를 남긴다
snapshot() {
  local pod
  pod=$(app_pod)
  k exec "$pod" -- wget -qO- localhost:8080/probe/nmt > "$OUT/nmt-$1.txt" 2>/dev/null || true
  k exec "$pod" -- wget -qO- localhost:8080/probe/threads > "$OUT/threads-$1.json" 2>/dev/null || true
}

restart_app() {
  k rollout restart deploy/outage-lab-app >/dev/null
  # 이전 파드가 사라지기 전에 새 파드를 잡지 않도록, 새 레플리카셋 파드가 생길 때까지 기다린다
  local before=$1
  until [ "$(app_pod)" != "$before" ] && [ -n "$(app_pod)" ]; do sleep 1; done
  follow_app
}

wait_hbase_tables() {
  # grep -q 는 찾자마자 끝나 앞 명령이 SIGPIPE 로 실패하고, pipefail 에서는 그 실패가 결과가 된다. 출력을 받아 비교한다.
  until [[ "$(k exec deploy/pinpoint-hbase -c hbase -- sh -c 'echo list | /opt/hbase/hbase-1.2.6/bin/hbase shell 2>/dev/null' 2>/dev/null || true)" == *"15 row(s)"* ]]; do
    sleep 5
  done
}

wait_collector() {
  local pod
  until pod=$(k get pods -l app=pinpoint-collector -o jsonpath='{.items[0].metadata.name}' 2>/dev/null) \
      && [[ "$(k logs "$pod" 2>/dev/null || true)" == *"Started CollectorApp"* ]]; do
    sleep 3
  done
}

# 3초마다 파드 컨테이너의 CPU · 메모리 (기동 중처럼 앱 프로브가 아직 없는 구간도 잡는다)
sample_containers() {
  echo "epoch_ms,container,cpu_pct,mem" > "$OUT/containers.csv"
  # 장애 주입으로 컨테이너가 ps 와 inspect 사이에 사라지면 inspect 가 실패한다. 표본 하나를 버리고 계속 돈다.
  set +e
  while true; do
    ids=$(docker ps -q --filter "label=io.kubernetes.pod.namespace=$NS" | xargs -r docker inspect \
      --format '{{.Id}} {{index .Config.Labels "io.kubernetes.container.name"}}' 2>/dev/null | awk '$2!="POD" {print $1}')
    if [ -n "$ids" ]; then
      ts=$(now_ms)
      # shellcheck disable=SC2086
      docker stats --no-stream --format '{{.Container}},{{.CPUPerc}},{{.MemUsage}}' $ids 2>/dev/null \
        | while IFS=, read -r id cpu mem; do
            name=$(docker inspect --format '{{index .Config.Labels "io.kubernetes.container.name"}}' "$id" 2>/dev/null || echo gone)
            echo "$ts,$name,${cpu%\%},${mem%% /*}"
          done >> "$OUT/containers.csv"
    fi
    sleep 3
  done
}

log "회차 $RUN_ID · 결과 $OUT"
{
  echo "normal=$NORMAL outage=$OUTAGE recover=$RECOVER restart=$RESTART"
  echo "node=$node"
  kubectl version 2>/dev/null | grep Server || true
  docker info --format 'docker_cpus={{.NCPU}} docker_mem={{.MemTotal}}'
  # 스레드 스택 커밋이 huge page 합치기에 영향을 받는다 (README 4.4). Rancher Desktop VM 에서만 읽힌다.
  echo "thp=$(rdctl shell cat /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null || echo unknown)"
  echo "thp_max_ptes_none=$(rdctl shell cat /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none 2>/dev/null || echo unknown)"
} > "$OUT/env.txt"

# 이전 회차의 파드를 모두 내리고 새 파드로 시작한다. HBase 데이터는 컨테이너 안에 있어 함께 비워진다.
kubectl apply -f k8s/pinpoint-storage.yaml >/dev/null
scale_all 0
until [ -z "$(k get pods -o name 2>/dev/null)" ]; do sleep 2; done
k scale deploy/zoo1 deploy/pinpoint-hbase --replicas=1 >/dev/null
log "HBase 테이블 대기"
k rollout status deploy/pinpoint-hbase --timeout=600s >/dev/null
wait_hbase_tables
record_clock
kubectl apply -f k8s/pinpoint-collector.yaml >/dev/null
k scale deploy/pinpoint-collector --replicas=1 >/dev/null
log "컬렉터 대기"
wait_collector

sample_containers &
PIDS+=($!)
follow_collectors &
PIDS+=($!)

kubectl apply -f k8s/app.yaml >/dev/null
k scale deploy/outage-lab-app --replicas=1 >/dev/null
kubectl apply -f k8s/load.yaml >/dev/null
mark startup
follow_app
wait_app_ready
sleep 30

mark normal
k scale deploy/k6 --replicas=1 >/dev/null
sleep "$NORMAL"
snapshot normal

mark restart_normal
restart_app "$(app_pod)"
wait_app_ready
sleep "$RESTART"
snapshot restart_normal

# 장애 셋은 같은 순서로 진행한다: 장애 유지 → 장애 중 재기동 → 복구.
# 원천의 확실한 장애(컬렉터 다운 · HBase 락 타임아웃 · HBase 다운)만 넣는다. 컬렉터 다운은 두 모습이다 (faults.sh).
for fault in collector_down collector_unresponsive hbase_lock_timeout hbase_down; do
  mark "$fault"
  "${fault}_on"
  sleep "$OUTAGE"
  snapshot "$fault"

  mark "restart_$fault"
  restart_app "$(app_pod)"
  wait_app_ready
  sleep "$RESTART"
  snapshot "restart_$fault"

  mark "${fault}_recover"
  "${fault}_off"
  [ "$fault" = collector_down ] && wait_collector
  sleep "$RECOVER"
  snapshot "${fault}_recover"
done

mark end
record_clock
k scale deploy/k6 --replicas=0 >/dev/null
log "끝. 분석: .venv/bin/python scripts/analyze.py $OUT"
