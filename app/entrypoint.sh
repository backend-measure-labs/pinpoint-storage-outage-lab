#!/bin/sh
# AGENT=off 이면 에이전트 없이 띄운다. NMT=detail 이면 스레드 스택을 영역별로 볼 수 있다 (스택 귀속 실험)
if [ "${AGENT:-on}" = "on" ]; then
  AGENT_OPTS="-javaagent:/app/pinpoint-agent/pinpoint-bootstrap-${PINPOINT_VERSION}.jar
    -Dpinpoint.agentId=${POD_IP}
    -Dpinpoint.applicationName=outage-lab
    -Dpinpoint.profiler.profiles.active=release"
fi
exec java $JAVA_OPTS $AGENT_OPTS \
  -XX:NativeMemoryTracking=${NMT:-summary} \
  -server \
  -Dspring.jmx.enabled=false \
  -Dsun.net.inetaddr.ttl=0 \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:InitiatingHeapOccupancyPercent=45 \
  -XX:ParallelGCThreads=4 \
  -XX:ConcGCThreads=1 \
  -jar /app/app.jar
