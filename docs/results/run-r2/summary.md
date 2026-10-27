# run-r2

```
normal=300 outage=420 recover=180 restart=240
node=lima-rancher-desktop
Server Version: v1.30.5+k3s1
docker_cpus=4 docker_mem=8320729088
```

## 단계별 앱 자원

| 단계 | 시간(s) | RSS 중앙 · 최대(MB) | RSS 변화(MB) | 힙 최저(MB) | NMT Other 끝(MB) | NMT Thread 끝(MB) | 스레드 최대 (핀포인트 · Tomcat) | 컬렉터 연결 ESTAB · SYN_SENT · TIME_WAIT 최대 | 받은 연결 최대 | fd 최대 | CPU 평균(%) | 요청 평균 · 최대(ms) | 처리 중 최대 | 100ms 도착 최대 | 오류 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 기동 | 33 | 286.6 · 311.2 | - | 48.3 | 16.2 | 7.4 | 45 (18 · 10) | 4 · 0 · 0 | 0 | 193 | 3.6 | 10.00 · 43.9 | 1 | 1 | 0 |
| 정상 | 300 | 306.4 · 320.1 | 5.4 | 28.9 | 16.2 | 7.2 | 47 (18 · 10) | 4 · 0 · 0 | 54 | 252 | 9.4 | 5.72 · 89.2 | 7 | 13 | 0 |
| 정상 중 재기동 | 244 | 294.9 · 324.8 | 4.1 | 29.7 | 16.2 | 7.2 | 47 (18 · 10) | 4 · 0 · 0 | 54 | 252 | 10.3 | 5.72 · 85.8 | 8 | 14 | 0 |
| 컬렉터 다운 | 420 | 298.0 · 299.1 | 1.6 | 33.1 | 16.2 | 7.3 | 45 (18 · 10) | 4 · 0 · 0 | 53 | 246 | 4.8 | 5.68 · 31.6 | 6 | 13 | 0 |
| 컬렉터 다운 중 재기동 | 244 | 299.9 · 309.9 | 10.2 | 28.1 | 0.2 | 9.0 | 46 (18 · 10) | 0 · 4 · 0 | 53 | 249 | 8.9 | 5.75 · 71.0 | 7 | 13 | 0 |
| 컬렉터 복구 | 186 | 307.3 · 309.7 | 5.4 | 27.2 | 14.2 | 9.2 | 44 (19 · 10) | 4 · 0 · 0 | 52 | 246 | 6.2 | 5.66 · 21.7 | 2 | 13 | 0 |
| 컬렉터 응답 없음 | 420 | 309.4 · 321.4 | 12.2 | 33.4 | 14.2 | 9.3 | 45 (19 · 10) | 5 · 0 · 0 | 53 | 251 | 4.4 | 5.67 · 48.3 | 6 | 13 | 0 |
| 컬렉터 응답 없음 중 재기동 | 244 | 284.5 · 321.3 | 1.2 | 27.8 | 8.2 | 7.0 | 45 (19 · 10) | 5 · 0 · 0 | 54 | 252 | 9.6 | 5.79 · 81.4 | 8 | 16 | 0 |
| 컬렉터 응답 복구 | 180 | 317.2 · 319.3 | 17.2 | 27.8 | 16.2 | 15.7 | 44 (19 · 10) | 4 · 0 · 0 | 55 | 254 | 6.8 | 5.72 · 90.1 | 9 | 15 | 0 |
| HBase 락 타임아웃 | 420 | 319.9 · 326.2 | 1.0 | 32.9 | 16.2 | 15.7 | 45 (19 · 10) | 4 · 0 · 0 | 53 | 250 | 5.1 | 5.67 · 32.3 | 5 | 13 | 0 |
| HBase 락 타임아웃 중 재기동 | 245 | 313.1 · 320.8 | 16.3 | 27.8 | 16.2 | 7.3 | 48 (19 · 10) | 4 · 0 · 0 | 52 | 247 | 9.5 | 5.75 · 57.1 | 6 | 13 | 0 |
| HBase 락 타임아웃 해제 | 180 | 315.3 · 321.5 | -0.5 | 32.9 | 16.2 | 7.5 | 45 (19 · 10) | 4 · 0 · 0 | 52 | 248 | 5.8 | 5.92 · 22.5 | 4 | 13 | 0 |
| HBase 다운 | 420 | 316.4 · 322.0 | 1.1 | 32.2 | 16.2 | 7.3 | 45 (19 · 10) | 3 · 0 · 0 | 51 | 245 | 4.4 | 5.91 · 15.7 | 3 | 13 | 0 |
| HBase 다운 중 재기동 | 244 | 308.3 · 325.1 | 33.6 | 28.7 | 16.2 | 20.9 | 47 (19 · 10) | 4 · 0 · 0 | 54 | 252 | 9.6 | 6.02 · 87.8 | 8 | 13 | 0 |
| HBase 복구 | 189 | 326.0 · 328.8 | 0.4 | 32.3 | 16.2 | 21.0 | 45 (19 · 10) | 4 · 0 · 0 | 52 | 248 | 5.4 | 5.93 · 20.1 | 4 | 13 | 0 |

## 기동

JVM 시작 시각(RuntimeMXBean)부터 잰다. 기동 CPU 는 첫 프로브 표본의 누적 프로세스 CPU 시간이다 (스프링 기동 완료 직후).

| 시작 단계 | 첫 프로브까지(s) | 기동 CPU(s) | 첫 프로브 RSS(MB) | 120초 안 RSS 최대(MB) | 120초 안 스레드 최대 | 120초 안 컬렉터 연결 최대 ESTAB · SYN_SENT · TIME_WAIT | 120초 안 CPU 최대(%) |
|---|---|---|---|---|---|---|---|
| 기동 | 2.9 | 6.89 | 311.1 | 311.2 | 47 | 4 · 0 · 0 | 55.5 |
| 정상 중 재기동 | 2.7 | 6.64 | 324.8 | 324.8 | 47 | 4 · 0 · 0 | 54.7 |
| 컬렉터 다운 중 재기동 | 2.4 | 6.30 | 309.9 | 309.9 | 46 | 0 · 4 · 0 | 66.2 |
| 컬렉터 응답 없음 중 재기동 | 2.9 | 6.08 | 281.3 | 290.8 | 45 | 4 · 0 · 0 | 56.7 |
| HBase 락 타임아웃 중 재기동 | 2.6 | 5.27 | 279.9 | 313.4 | 48 | 4 · 0 · 0 | 47.1 |
| HBase 다운 중 재기동 | 2.5 | 6.39 | 288.7 | 298.5 | 47 | 4 · 0 · 0 | 51.8 |

## 서버 컨테이너 메모리 (단계 끝 값, MB)

| 단계 | 컬렉터 | HBase | ZooKeeper |
|---|---|---|---|
| 기동 | 2,345.0 | 853.9 | 73.5 |
| 정상 | 2,365.4 | 1,400.8 | 77.8 |
| 정상 중 재기동 | 2,386.9 | 1,456.1 | 87.4 |
| 컬렉터 다운 | 2,294.8 | 1,462.3 | 87.5 |
| 컬렉터 다운 중 재기동 | - | 1,462.3 | 87.5 |
| 컬렉터 복구 | - | - | - |
| 컬렉터 응답 없음 | - | - | - |
| 컬렉터 응답 없음 중 재기동 | - | - | - |
| 컬렉터 응답 복구 | - | - | - |
| HBase 락 타임아웃 | - | - | - |
| HBase 락 타임아웃 중 재기동 | - | - | - |
| HBase 락 타임아웃 해제 | - | - | - |
| HBase 다운 | - | - | - |
| HBase 다운 중 재기동 | - | - | - |
| HBase 복구 | - | - | - |

## 에이전트 로그 (앱 파드) WARN · ERROR

| 단계 | 레벨 | 로거 | 메시지 (숫자는 N) | 건수 |
|---|---|---|---|---|
| 컬렉터 다운 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: io exception | 19 |
| 컬렉터 다운 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=CANCELLED: RST_STREAM closed stream. HTTP/N error code: CANCEL | 1 |
| 컬렉터 다운 중 재기동 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: io exception | 14 |
| 컬렉터 다운 중 재기동 | WARN | c.n.p.p.AgentInfoSender | -- request failed. | 5 |
| 컬렉터 복구 | WARN | c.n.p.p.AgentInfoSender | -- request failed. | 5 |
| 컬렉터 복구 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: io exception | 4 |
| 컬렉터 응답 없음 | WARN | c.n.p.p.AgentInfoSender | -- request timed out while waiting for response. | 5 |
| 컬렉터 응답 없음 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: Keepalive failed. The connection is likely gone | 1 |
| 컬렉터 응답 없음 중 재기동 | WARN | c.n.p.p.AgentInfoSender | -- request timed out while waiting for response. | 5 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.p.AgentInfoSender | -- request timed out while waiting for response. | 5 |
| HBase 다운 중 재기동 | WARN | c.n.p.p.AgentInfoSender | -- request timed out while waiting for response. | 5 |

| 단계 | WARN · ERROR 전체 건수 |
|---|---|
| 기동 | 0 |
| 정상 | 0 |
| 정상 중 재기동 | 0 |
| 컬렉터 다운 | 20 |
| 컬렉터 다운 중 재기동 | 19 |
| 컬렉터 복구 | 9 |
| 컬렉터 응답 없음 | 6 |
| 컬렉터 응답 없음 중 재기동 | 5 |
| 컬렉터 응답 복구 | 0 |
| HBase 락 타임아웃 | 0 |
| HBase 락 타임아웃 중 재기동 | 5 |
| HBase 락 타임아웃 해제 | 0 |
| HBase 다운 | 0 |
| HBase 다운 중 재기동 | 5 |
| HBase 복구 | 0 |

## 컬렉터 로그 WARN · ERROR

| 단계 | 레벨 | 로거 | 메시지 (숫자는 N) | 건수 |
|---|---|---|---|---|
| 컬렉터 다운 | WARN | c.n.p.c.r.g.s.StatService | Failed to stat stream, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 다운 | WARN | c.n.p.c.r.g.s.SpanService | Failed to span stream, Header{name='span', agentId='N.N.N.N', agentName='null', applicationName='outage-lab',  | 1 |
| 컬렉터 다운 | WARN | c.n.p.c.r.g.s.AgentService | Failed to ping stream, id=N, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 다운 | WARN | c.n.p.c.r.g.s.c.GrpcCommandService | Failed to command stream, outage-lab:N.N.N.N:N => local, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 복구 | WARN | o.a.h.u.NativeCodeLoader | Unable to load native-hadoop library for your platform... using builtin-java classes where applicable | 1 |
| 컬렉터 복구 | WARN | c.n.p.c.r.g.GrpcReceiver | grpcAgentSslReceiver is false | 1 |
| 컬렉터 복구 | WARN | c.n.p.c.r.g.GrpcReceiver | grpcSpanSslReceiver is false | 1 |
| 컬렉터 복구 | WARN | c.n.p.c.r.g.GrpcReceiver | grpcStatSslReceiver is false | 1 |
| 컬렉터 복구 | WARN | spanUdpReceiver | DatagramSocket.setReceiveBufferSize() error. N!=N | 1 |
| 컬렉터 복구 | WARN | statUdpReceiver | DatagramSocket.setReceiveBufferSize() error. N!=N | 1 |
| 컬렉터 응답 없음 중 재기동 | WARN | o.a.h.h.s.o.a.z.ClientCnxn | Client session timed out, have not heard from server in Nms for sessionid NxNaaNffdN | 2 |
| 컬렉터 응답 없음 중 재기동 | WARN | o.a.z.ClientCnxn | Client session timed out, have not heard from server in Nms for sessionid NxNaaNffdN | 1 |
| 컬렉터 응답 없음 중 재기동 | WARN | c.n.p.c.r.g.s.StatService | Failed to stat stream, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 응답 없음 중 재기동 | WARN | c.n.p.c.r.g.s.AgentService | ping message is ignored: stream is not ready: Header{name='agent', agentId='N.N.N.N', agentName='null', applic | 1 |
| 컬렉터 응답 없음 중 재기동 | WARN | c.n.p.c.r.g.s.c.GrpcCommandService | Failed to command stream, outage-lab:N.N.N.N:N => local, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 응답 없음 중 재기동 | WARN | c.n.p.c.c.z.ZookeeperJobWorker | handleUpdate failed. caused:Instance must be connected. connectionState:SUSPENDED, jobSize:N | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.c.z.ZookeeperJobWorker | handleUpdate failed. caused:Instance must be connected. connectionState:SUSPENDED, jobSize:N | 2 |
| 컬렉터 응답 복구 | WARN | o.a.h.h.s.o.a.z.ClientCnxn | Unable to reconnect to ZooKeeper service, session NxNaaNffdN has expired | 2 |
| 컬렉터 응답 복구 | WARN | nectionManager$HConnectionImplementation | This client just lost it's session with ZooKeeper, closing it. It will be recreated next time someone needs it | 2 |
| 컬렉터 응답 복구 | WARN | o.a.z.ClientCnxn | Unable to reconnect to ZooKeeper service, session NxNaaNffdN has expired | 1 |
| 컬렉터 응답 복구 | WARN | o.a.c.ConnectionState | Session expired event received | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.c.z.ZookeeperJobWorker | getClusterData failed. message:KeeperErrorCode = NoNode for /pinpoint-cluster/collector/pinpoint-collector-Ndf | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.r.g.s.SpanService | Failed to span stream, Header{name='span', agentId='N.N.N.N', agentName='null', applicationName='outage-lab',  | 1 |
| HBase 락 타임아웃 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 52 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 50 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 48 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 25 |
| HBase 락 타임아웃 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 15 |
| HBase 락 타임아웃 | WARN | c.n.p.c.d.h.HbaseHostApplicationMapDao | retry one. Caused:org.apache.hadoop.hbase.client.RetriesExhaustedWithDetailsException: Failed N action: Failed | 7 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: -N parentSpanId: -N s | 3 |
| HBase 락 타임아웃 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.io.IOException: Call to pinpoint-hbase:N failed  | 2 |
| HBase 락 타임아웃 | ERROR | .a.i.SimpleAsyncUncaughtExceptionHandler | Unexpected exception occurred invoking async method: public void com.navercorp.pinpoint.collector.service.asyn | 2 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: N parentSpanId: -N st | 2 |
| HBase 락 타임아웃 중 재기동 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 327 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(java.io. | 33 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 30 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 28 |
| HBase 락 타임아웃 중 재기동 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 28 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(java.io. | 24 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(com.fast | 21 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(byte[] s | 18 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValues(com.fas | 15 |
| HBase 락 타임아웃 중 재기동 | ERROR | .a.i.SimpleAsyncUncaughtExceptionHandler | Unexpected exception occurred invoking async method: public void com.navercorp.pinpoint.collector.service.asyn | 14 |
| HBase 락 타임아웃 해제 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 2 |
| HBase 락 타임아웃 해제 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.io.IOException: Call to pinpoint-hbase:N failed  | 1 |
| HBase 다운 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 49 |
| HBase 다운 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 49 |
| HBase 다운 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 46 |
| HBase 다운 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 25 |
| HBase 다운 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 16 |
| HBase 다운 | WARN | c.n.p.c.d.h.HbaseHostApplicationMapDao | retry one. Caused:org.apache.hadoop.hbase.client.RetriesExhaustedWithDetailsException: Failed N action: Failed | 7 |
| HBase 다운 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: N parentSpanId: N sta | 3 |
| HBase 다운 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: N parentSpanId: -N st | 2 |
| HBase 다운 | ERROR | .a.i.SimpleAsyncUncaughtExceptionHandler | Unexpected exception occurred invoking async method: public void com.navercorp.pinpoint.collector.service.asyn | 2 |
| HBase 다운 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: -N parentSpanId: -N s | 1 |
| HBase 다운 중 재기동 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 327 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(java.io. | 33 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 27 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 26 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(java.io. | 24 |
| HBase 다운 중 재기동 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 23 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(com.fast | 21 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(byte[] s | 18 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 15 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValues(com.fas | 15 |
| HBase 복구 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.io.IOException: Call to pinpoint-hbase:N failed  | 49 |
| HBase 복구 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.net.ConnectException: Call to pinpoint-hbase:N f | 4 |
| HBase 복구 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 3 |
| HBase 복구 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:callTimeout=N, callDuration=N: Call to pinpoint-hba | 1 |
| HBase 복구 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:callTimeout=N, callDuration=N: Call to pinpoint-hba | 1 |
| HBase 복구 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:callTimeout=N, callDuration=N: Call to pinpoint-hbase | 1 |
| - | WARN | c.n.p.c.c.z.ZookeeperJobWorker | handleDelete failed. caused:Instance must be connected. connectionState:SUSPENDED, jobSize:N | 9 |
| - | WARN | o.a.h.h.s.o.a.z.ClientCnxn | Session NxNaaNffdN for server null, unexpected error, closing socket connection and attempting reconnect | 4 |
| - | WARN | o.a.h.u.NativeCodeLoader | Unable to load native-hadoop library for your platform... using builtin-java classes where applicable | 1 |
| - | WARN | c.n.p.c.r.g.GrpcReceiver | grpcAgentSslReceiver is false | 1 |
| - | WARN | c.n.p.c.r.g.GrpcReceiver | grpcSpanSslReceiver is false | 1 |
| - | WARN | c.n.p.c.r.g.GrpcReceiver | grpcStatSslReceiver is false | 1 |
| - | WARN | spanUdpReceiver | DatagramSocket.setReceiveBufferSize() error. N!=N | 1 |
| - | WARN | statUdpReceiver | DatagramSocket.setReceiveBufferSize() error. N!=N | 1 |

| 단계 | WARN · ERROR 전체 건수 |
|---|---|
| 기동 | 0 |
| 정상 | 0 |
| 정상 중 재기동 | 0 |
| 컬렉터 다운 | 4 |
| 컬렉터 다운 중 재기동 | 0 |
| 컬렉터 복구 | 6 |
| 컬렉터 응답 없음 | 0 |
| 컬렉터 응답 없음 중 재기동 | 7 |
| 컬렉터 응답 복구 | 10 |
| HBase 락 타임아웃 | 213 |
| HBase 락 타임아웃 중 재기동 | 763 |
| HBase 락 타임아웃 해제 | 3 |
| HBase 다운 | 202 |
| HBase 다운 중 재기동 | 754 |
| HBase 복구 | 59 |

## 단계 끝 스레드 (이름별, 핀포인트 · gRPC 만)

- 정상: 전체 43 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 정상 중 재기동: 전체 43 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 다운: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
- 컬렉터 다운 중 재기동: 전체 43 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
- 컬렉터 복구: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 응답 없음: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 응답 없음 중 재기동: 전체 41 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 응답 복구: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 락 타임아웃: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 락 타임아웃 중 재기동: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 락 타임아웃 해제: 전체 45 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
- HBase 다운: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 다운 중 재기동: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 복구: 전체 45 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
