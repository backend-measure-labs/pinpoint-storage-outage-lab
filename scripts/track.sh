#!/usr/bin/env bash
# 진행 중인 회차를 한 번 들여다본다. 읽기만 한다.
#   scripts/track.sh [최근 초, 기본 120]
set -uo pipefail
cd "$(dirname "$0")/.."
NS=pinpoint-lab
SINCE=${1:-120}
lab_kubeconfig=$(mktemp)
kubectl config view --minify --flatten --context "${LAB_CONTEXT:-rancher-desktop}" > "$lab_kubeconfig"
export KUBECONFIG=$lab_kubeconfig
trap 'rm -f "$lab_kubeconfig"' EXIT
k() { kubectl -n "$NS" "$@"; }

echo "== $(date +%H:%M:%S) 마지막 단계: $(tail -1 reports/run-*/events.csv 2>/dev/null | tail -1)"
k get pods --no-headers 2>/dev/null | awk '{print "   " $1, $2, $3, $4}'

echo "== 앱 프로브 (최근 ${SINCE}초, 20초 간격)"
app=$(k get pods -l app=outage-lab-app --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1:].metadata.name}' 2>/dev/null)
[ -n "$app" ] && k logs "$app" --since="${SINCE}s" 2>/dev/null | grep '^PROBE,1' | awk -F, '
  NR==1 {c0=$14; t0=$2}
  NR%10==1 {printf "   rss=%.0fMB heap=%.0fMB other=%.1fMB thread=%.1fMB thr=%d(pp %d) col=%d/%d/%d in=%d req=%d avg=%sms max=%sms act=%d err=%d\n",
    $11/1024, $3/1048576, $37/1024, $33/1024, $8, $9, $18, $19, $20, $23, $25, $27, $28, $29, $26}
  END {if (NR>1) printf "   CPU 평균 %.1f%%\n", ($14-c0)/($2-t0)*100}'

echo "== 컬렉터 WARN · ERROR (최근 ${SINCE}초, 숫자는 N)"
k logs deploy/pinpoint-collector --since="${SINCE}s" 2>/dev/null | grep -E ' (WARN|ERROR) ' | cut -c20-170 \
  | sed 's/[0-9]\{2,\}/N/g' | sort | uniq -c | sort -rn | head -6

echo "== 에이전트 WARN · ERROR (최근 ${SINCE}초)"
[ -n "$app" ] && k logs "$app" --since="${SINCE}s" 2>/dev/null | grep -v '^PROBE' | grep -E ' (WARN|ERROR) ' | cut -c20-170 \
  | sed 's/[0-9]\{2,\}/N/g' | sort | uniq -c | sort -rn | head -6

echo "== 컨테이너"
ids=$(docker ps -q --filter "label=io.kubernetes.pod.namespace=$NS")
[ -n "$ids" ] && docker stats --no-stream --format '{{.Name}} {{.CPUPerc}} {{.MemUsage}}' $ids \
  | grep -v '_POD_' | sed 's/^k8s_\([a-z0-9-]*\)_[^ ]* /   \1 /'

if [ "${COUNT:-0}" = 1 ]; then
  echo "== HBase 저장 건수"
  k exec deploy/pinpoint-hbase -c hbase -- sh -c 'printf "count \"TraceV2\"\ncount \"AgentStatV2\"\n" | timeout 60 /opt/hbase/hbase-1.2.6/bin/hbase shell 2>/dev/null' \
    | grep 'row(s)' | sed 's/^/   /'
fi
