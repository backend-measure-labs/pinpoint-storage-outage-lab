#!/usr/bin/env bash
# 「HBase 다운 중 재기동」에서 늘어난 스레드 스택이 어느 스레드 것인지 가린다.
# 정상 재기동과 HBase 다운 중 재기동을 한 번씩 하고, 각각 240초 뒤 NMT 상세와 스레드 덤프를 남긴다.
# 짝짓기는 scripts/stack_attribution.py.
set -euo pipefail
cd "$(dirname "$0")/.."

NS=pinpoint-lab
LAB_CONTEXT=${LAB_CONTEXT:-rancher-desktop}
LAB_NODE=${LAB_NODE:-lima-rancher-desktop}
WAIT=${WAIT:-240}
OUT=reports/stack-$(date +%Y%m%d-%H%M%S)
mkdir -p "$OUT"

lab_kubeconfig=$(mktemp)
kubectl config view --minify --flatten --context "$LAB_CONTEXT" > "$lab_kubeconfig"
export KUBECONFIG=$lab_kubeconfig
node=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
if [ "$node" != "$LAB_NODE" ]; then
  echo "로컬 노드가 아니다: '$node' (기대: $LAB_NODE). 멈춘다." >&2
  rm -f "$lab_kubeconfig"
  exit 1
fi
# shellcheck source=scripts/faults.sh
. scripts/faults.sh

k() { kubectl -n "$NS" "$@"; }
log() { echo "[$(date +%H:%M:%S)] $*"; }
scale_all() { k get deploy -o name 2>/dev/null | xargs -r kubectl -n "$NS" scale --replicas="$1" >/dev/null 2>&1 || true; }
cleanup() {
  # 중단돼도 디플로이먼트에 NMT=detail 이 남지 않게 한다. 남으면 다음 run-lab.sh 회차가 detail 로 뜬다.
  k set env deploy/outage-lab-app NMT- >/dev/null 2>&1 || true
  hbase_down_off >/dev/null 2>&1 || true
  [ "${KEEP:-0}" = 1 ] || scale_all 0
  rm -f "$lab_kubeconfig"
}
trap cleanup EXIT

app_pod() {
  k get pods -l app=outage-lab-app --sort-by=.metadata.creationTimestamp \
    -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.deletionTimestamp}{"\n"}{end}' \
    | awk 'NF==1 {p=$1} END {print p}'
}

restart_and_dump() {
  local name=$1 before pod
  before=$(app_pod)
  k rollout restart deploy/outage-lab-app >/dev/null
  until [ "$(app_pod)" != "$before" ] && [ -n "$(app_pod)" ]; do sleep 1; done
  k rollout status deploy/outage-lab-app --timeout=600s >/dev/null
  pod=$(app_pod)
  log "$name: $pod, ${WAIT}초 대기"
  sleep "$WAIT"
  k exec "$pod" -- jcmd 1 VM.native_memory detail > "$OUT/nmt-detail-$name.txt"
  k exec "$pod" -- jcmd 1 Thread.print > "$OUT/threads-$name.txt"
}

kubectl apply -f k8s/pinpoint-storage.yaml >/dev/null
scale_all 0
until [ -z "$(k get pods -o name 2>/dev/null)" ]; do sleep 2; done
k scale deploy/zoo1 deploy/pinpoint-hbase --replicas=1 >/dev/null
k rollout status deploy/pinpoint-hbase --timeout=600s >/dev/null
until [[ "$(k exec deploy/pinpoint-hbase -c hbase -- sh -c 'echo list | /opt/hbase/hbase-1.2.6/bin/hbase shell 2>/dev/null' 2>/dev/null || true)" == *"15 row(s)"* ]]; do sleep 5; done
kubectl apply -f k8s/pinpoint-collector.yaml >/dev/null
k scale deploy/pinpoint-collector --replicas=1 >/dev/null
until pod=$(k get pods -l app=pinpoint-collector -o jsonpath='{.items[0].metadata.name}' 2>/dev/null) \
    && [[ "$(k logs "$pod" 2>/dev/null || true)" == *"Started CollectorApp"* ]]; do sleep 3; done
kubectl apply -f k8s/app.yaml >/dev/null
k set env deploy/outage-lab-app NMT=detail >/dev/null
k scale deploy/outage-lab-app --replicas=1 >/dev/null
kubectl apply -f k8s/load.yaml >/dev/null
k rollout status deploy/outage-lab-app --timeout=600s >/dev/null
k scale deploy/k6 --replicas=1 >/dev/null
log "정상 부하 60초"
sleep 60

restart_and_dump normal_restart
log "HBase 다운"
hbase_down_on
restart_and_dump hbase_down_restart
log "끝. 짝짓기: python3 scripts/stack_attribution.py $OUT"
