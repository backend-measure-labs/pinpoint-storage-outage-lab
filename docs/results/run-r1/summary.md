# run-r1

```
normal=300 outage=420 recover=180 restart=240
node=lima-rancher-desktop
Server Version: v1.30.5+k3s1
docker_cpus=4 docker_mem=8320729088
```

## 단계별 앱 자원

| 단계 | 시간(s) | RSS 중앙 · 최대(MB) | RSS 변화(MB) | 힙 최저(MB) | NMT Other 끝(MB) | NMT Thread 끝(MB) | 스레드 최대 (핀포인트 · Tomcat) | 컬렉터 연결 ESTAB · SYN_SENT · TIME_WAIT 최대 | 받은 연결 최대 | fd 최대 | CPU 평균(%) | 요청 평균 · 최대(ms) | 처리 중 최대 | 100ms 도착 최대 | 오류 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 기동 | 34 | 300.6 · 317.6 | - | 53.3 | 16.2 | 7.5 | 46 (18 · 10) | 4 · 0 · 0 | 0 | 193 | 3.3 | 9.56 · 41.2 | 1 | 1 | 0 |
| 정상 | 300 | 297.8 · 299.4 | 6.8 | 27.8 | 16.2 | 7.3 | 47 (18 · 10) | 4 · 0 · 0 | 53 | 250 | 8.6 | 5.65 · 91.2 | 8 | 11 | 0 |
| 정상 중 재기동 | 244 | 287.3 · 313.1 | 4.7 | 27.9 | 16.2 | 7.3 | 48 (18 · 10) | 4 · 0 · 0 | 54 | 252 | 10.3 | 5.70 · 93.2 | 6 | 12 | 0 |
| 컬렉터 다운 | 420 | 290.9 · 297.4 | -0.2 | 35.7 | 16.2 | 7.5 | 46 (18 · 10) | 4 · 0 · 0 | 52 | 246 | 5.2 | 5.67 · 28.7 | 4 | 11 | 0 |
| 컬렉터 다운 중 재기동 | 244 | 280.2 · 299.1 | 13.6 | 25.9 | 0.2 | 13.1 | 47 (18 · 10) | 0 · 4 · 0 | 54 | 252 | 9.4 | 5.70 · 75.9 | 6 | 11 | 0 |
| 컬렉터 복구 | 190 | 301.9 · 303.4 | 5.7 | 29.1 | 16.2 | 13.7 | 49 (19 · 14) | 4 · 0 · 0 | 55 | 254 | 7.5 | 5.64 · 100.9 | 12 | 17 | 0 |
| 컬렉터 응답 없음 | 420 | 304.4 · 309.3 | 0.6 | 36.5 | 16.2 | 13.7 | 50 (19 · 14) | 5 · 0 · 0 | 52 | 249 | 4.5 | 5.61 · 18.8 | 4 | 12 | 0 |
| 컬렉터 응답 없음 중 재기동 | 244 | 276.2 · 304.7 | -1.5 | 27.8 | 8.2 | 6.9 | 50 (19 · 14) | 5 · 0 · 0 | 52 | 248 | 9.0 | 5.72 · 47.4 | 4 | 12 | 0 |
| 컬렉터 응답 복구 | 180 | 282.0 · 289.3 | -1.2 | 29.5 | 16.2 | 7.4 | 44 (19 · 10) | 4 · 0 · 0 | 51 | 246 | 5.9 | 5.58 · 14.8 | 3 | 12 | 0 |
| HBase 락 타임아웃 | 420 | 283.1 · 293.0 | 1.3 | 33.2 | 16.2 | 7.4 | 45 (19 · 10) | 4 · 0 · 0 | 52 | 248 | 5.4 | 5.63 · 26.7 | 4 | 12 | 0 |
| HBase 락 타임아웃 중 재기동 | 244 | 288.9 · 295.5 | 3.8 | 27.8 | 16.2 | 7.4 | 48 (19 · 10) | 4 · 0 · 0 | 54 | 252 | 11.4 | 5.79 · 80.4 | 8 | 12 | 0 |
| HBase 락 타임아웃 해제 | 180 | 291.4 · 300.8 | -0.8 | 33.4 | 16.2 | 7.5 | 45 (19 · 10) | 4 · 0 · 0 | 53 | 250 | 6.7 | 5.67 · 60.9 | 5 | 14 | 0 |
| HBase 다운 | 420 | 292.4 · 300.8 | 1.0 | 32.6 | 16.2 | 7.4 | 45 (19 · 10) | 3 · 0 · 0 | 52 | 247 | 4.6 | 5.60 · 40.7 | 4 | 12 | 0 |
| HBase 다운 중 재기동 | 245 | 299.8 · 327.8 | 34.5 | 28.4 | 16.2 | 17.9 | 48 (19 · 10) | 4 · 0 · 0 | 54 | 252 | 11.4 | 5.76 · 84.7 | 6 | 13 | 0 |
| HBase 복구 | 194 | 325.6 · 327.0 | 0.3 | 32.2 | 16.2 | 18.0 | 45 (19 · 10) | 4 · 0 · 0 | 53 | 250 | 7.5 | 5.77 · 91.7 | 6 | 12 | 0 |

## 기동

JVM 시작 시각(RuntimeMXBean)부터 잰다. 기동 CPU 는 첫 프로브 표본의 누적 프로세스 CPU 시간이다 (스프링 기동 완료 직후).

| 시작 단계 | 첫 프로브까지(s) | 기동 CPU(s) | 첫 프로브 RSS(MB) | 120초 안 RSS 최대(MB) | 120초 안 스레드 최대 | 120초 안 컬렉터 연결 최대 ESTAB · SYN_SENT · TIME_WAIT | 120초 안 CPU 최대(%) |
|---|---|---|---|---|---|---|---|
| 기동 | 3.0 | 7 | 314.4 | 317.6 | 47 | 4 · 0 · 0 | 37.0 |
| 정상 중 재기동 | 3.0 | 5.95 | 313.1 | 313.1 | 48 | 4 · 0 · 0 | 55.2 |
| 컬렉터 다운 중 재기동 | 2.3 | 6.22 | 274.0 | 294.8 | 47 | 0 · 4 · 0 | 71.7 |
| 컬렉터 응답 없음 중 재기동 | 2.4 | 5.25 | 282.0 | 284.2 | 45 | 4 · 0 · 0 | 46.1 |
| HBase 락 타임아웃 중 재기동 | 2.6 | 5.26 | 292.8 | 295.5 | 48 | 4 · 0 · 0 | 52.6 |
| HBase 다운 중 재기동 | 2.9 | 6.97 | 293.8 | 306.4 | 48 | 4 · 0 · 0 | 63.1 |

## 서버 컨테이너 메모리 (단계 끝 값, MB)

| 단계 | 컬렉터 | HBase | ZooKeeper |
|---|---|---|---|
| 기동 | 2,323.5 | 1,390.6 | 73.8 |
| 정상 | 2,341.9 | 1,506.3 | 84.7 |
| 정상 중 재기동 | 2,355.2 | 1,558.5 | 84.7 |
| 컬렉터 다운 | 2,278.4 | 1,585.2 | 84.8 |
| 컬렉터 다운 중 재기동 | - | 1,591.3 | 84.8 |
| 컬렉터 복구 | 2,317.3 | 1,620.0 | 84.8 |
| 컬렉터 응답 없음 | 2,319.4 | 1,628.2 | 84.8 |
| 컬렉터 응답 없음 중 재기동 | 2,319.4 | 1,632.3 | 84.8 |
| 컬렉터 응답 복구 | 2,336.8 | 1,642.5 | 84.5 |
| HBase 락 타임아웃 | 2,349.1 | 1,651.7 | 84.5 |
| HBase 락 타임아웃 중 재기동 | 2,368.5 | 1,655.8 | 84.5 |
| HBase 락 타임아웃 해제 | 2,381.8 | 1,672.2 | 84.5 |
| HBase 다운 | 2,382.8 | 363.7 | 93.2 |
| HBase 다운 중 재기동 | 2,385.9 | 364 | 84.0 |
| HBase 복구 | 2,394.1 | 1,508.4 | 88.0 |

## 에이전트 로그 (앱 파드) WARN · ERROR

| 단계 | 레벨 | 로거 | 메시지 (숫자는 N) | 건수 |
|---|---|---|---|---|
| 컬렉터 다운 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: io exception | 19 |
| 컬렉터 다운 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=CANCELLED: RST_STREAM closed stream. HTTP/N error code: CANCEL | 1 |
| 컬렉터 다운 중 재기동 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: io exception | 14 |
| 컬렉터 다운 중 재기동 | WARN | c.n.p.p.AgentInfoSender | -- request failed. | 5 |
| 컬렉터 복구 | WARN | c.n.p.p.r.g.GrpcCommandService | -- Failed to command stream, cause=UNAVAILABLE: io exception | 2 |
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
| 컬렉터 복구 | 2 |
| 컬렉터 응답 없음 | 1 |
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
| 컬렉터 응답 복구 | WARN | o.a.h.h.s.o.a.z.ClientCnxn | Client session timed out, have not heard from server in Nms for sessionid NxNbcNfN | 2 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.c.z.ZookeeperJobWorker | handleUpdate failed. caused:Instance must be connected. connectionState:SUSPENDED, jobSize:N | 2 |
| 컬렉터 응답 복구 | WARN | o.a.h.h.s.o.a.z.ClientCnxn | Unable to reconnect to ZooKeeper service, session NxNbcNfN has expired | 2 |
| 컬렉터 응답 복구 | WARN | nectionManager$HConnectionImplementation | This client just lost it's session with ZooKeeper, closing it. It will be recreated next time someone needs it | 2 |
| 컬렉터 응답 복구 | WARN | o.a.z.ClientCnxn | Client session timed out, have not heard from server in Nms for sessionid NxNbcNfN | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.r.g.s.AgentService | ping message is ignored: stream is not ready: Header{name='agent', agentId='N.N.N.N', agentName='null', applic | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.r.g.s.StatService | Failed to stat stream, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.r.g.s.c.GrpcCommandService | Failed to command stream, outage-lab:N.N.N.N:N => local, cause=CANCELLED: client cancelled | 1 |
| 컬렉터 응답 복구 | WARN | c.n.p.c.c.z.ZookeeperJobWorker | handleUpdate failed. caused:KeeperErrorCode = ConnectionLoss for /pinpoint-cluster/collector, jobSize:N | 1 |
| 컬렉터 응답 복구 | WARN | o.a.z.ClientCnxn | Unable to reconnect to ZooKeeper service, session NxNbcNfN has expired | 1 |
| HBase 락 타임아웃 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 48 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 48 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 47 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 25 |
| HBase 락 타임아웃 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 16 |
| HBase 락 타임아웃 | WARN | c.n.p.c.d.h.HbaseHostApplicationMapDao | retry one. Caused:org.apache.hadoop.hbase.client.RetriesExhaustedWithDetailsException: Failed N action: Failed | 7 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: -N parentSpanId: -N s | 3 |
| HBase 락 타임아웃 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.io.IOException: Call to pinpoint-hbase:N failed  | 2 |
| HBase 락 타임아웃 | ERROR | .a.i.SimpleAsyncUncaughtExceptionHandler | Unexpected exception occurred invoking async method: public void com.navercorp.pinpoint.collector.service.asyn | 2 |
| HBase 락 타임아웃 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: N parentSpanId: -N st | 2 |
| HBase 락 타임아웃 중 재기동 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 327 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(java.io. | 33 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 30 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 28 |
| HBase 락 타임아웃 중 재기동 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 25 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(java.io. | 24 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(com.fast | 21 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(byte[] s | 18 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 17 |
| HBase 락 타임아웃 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValues(com.fas | 15 |
| HBase 락 타임아웃 해제 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 3 |
| HBase 락 타임아웃 해제 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.io.IOException: Call to pinpoint-hbase:N failed  | 1 |
| HBase 다운 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 50 |
| HBase 다운 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 49 |
| HBase 다운 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 49 |
| HBase 다운 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 27 |
| HBase 다운 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 16 |
| HBase 다운 | WARN | c.n.p.c.d.h.HbaseHostApplicationMapDao | retry one. Caused:org.apache.hadoop.hbase.client.RetriesExhaustedWithDetailsException: Failed N action: Failed | 7 |
| HBase 다운 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: N parentSpanId: N sta | 3 |
| HBase 다운 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: -N parentSpanId: N st | 2 |
| HBase 다운 | ERROR | .a.i.SimpleAsyncUncaughtExceptionHandler | Unexpected exception occurred invoking async method: public void com.navercorp.pinpoint.collector.service.asyn | 2 |
| HBase 다운 | WARN | c.n.p.c.h.g.GrpcSpanHandler | Failed to handle span=version: N transactionId { agentStartTime: N sequence: N } spanId: -N parentSpanId: -N s | 2 |
| HBase 다운 중 재기동 | ERROR | o.a.h.h.c.AsyncProcess | Failed to get region location  | 327 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(java.io. | 33 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 28 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:Failed to get user region lock inN ms.  for accessi | 28 |
| HBase 다운 중 재기동 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 28 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(java.io. | 24 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValue(com.fast | 21 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectMapper.readValue(byte[] s | 18 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsSelf_VerN increment error Caused:Failed to get user region lock inN ms.  for accessing | 16 |
| HBase 다운 중 재기동 | WARN | c.n.p.c.h.g.GrpcApiMetaDataHandler | Failed to handle apiMetaData=apiId: N apiInfo: "com.fasterxml.jackson.databind.ObjectReader.readValues(com.fas | 15 |
| HBase 복구 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.io.IOException: Call to pinpoint-hbase:N failed  | 71 |
| HBase 복구 | WARN | o.a.h.h.c.AsyncProcess | #N, table=null, attempt=N/N failed=Nops, last exception: java.net.ConnectException: Call to pinpoint-hbase:N f | 5 |
| HBase 복구 | ERROR | o.s.s.s.TaskUtils$LoggingErrorHandler | Unexpected error occurred in scheduled task | 3 |
| HBase 복구 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCaller_VerN increment error Caused:callTimeout=N, callDuration=N: Call to pinpoint-hba | 2 |
| HBase 복구 | WARN | c.n.p.c.h.HbaseTemplate2 | ApplicationMapStatisticsCallee_VerN increment error Caused:callTimeout=N, callDuration=N: Call to pinpoint-hba | 1 |
| - | WARN | c.n.p.c.c.z.ZookeeperJobWorker | handleDelete failed. caused:Instance must be connected. connectionState:SUSPENDED, jobSize:N | 9 |
| - | WARN | o.a.h.h.s.o.a.z.ClientCnxn | Session NxNbcNfN for server null, unexpected error, closing socket connection and attempting reconnect | 3 |
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
| 컬렉터 응답 없음 중 재기동 | 0 |
| 컬렉터 응답 복구 | 17 |
| HBase 락 타임아웃 | 206 |
| HBase 락 타임아웃 중 재기동 | 763 |
| HBase 락 타임아웃 해제 | 4 |
| HBase 다운 | 208 |
| HBase 다운 중 재기동 | 763 |
| HBase 복구 | 82 |

## 단계 끝 스레드 (이름별, 핀포인트 · gRPC 만)

- 정상: 전체 43 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 정상 중 재기동: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 다운: 전체 45 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
- 컬렉터 다운 중 재기동: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
- 컬렉터 복구: 전체 49 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 응답 없음: 전체 49 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 응답 없음 중 재기동: 전체 41 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- 컬렉터 응답 복구: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 락 타임아웃: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 락 타임아웃 중 재기동: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 락 타임아웃 해제: 전체 45 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
- HBase 다운: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 다운 중 재기동: 전체 44 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1
- HBase 복구: 전체 45 · `Pinpoint-AgentGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-AgentGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-AgentInfoSender-Timer` 1, `Pinpoint-DefaultChannelzScheduledReporter(N-N)` 1, `Pinpoint-Grpc-ActiveThreadCountService-Timer` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-MetadataGrpcDataSender-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-SpanGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Executor(N-N)` 1, `Pinpoint-StatGrpcDataSender-Channel-Worker(N-N)` 1, `Pinpoint-StatGrpcDataSender-Executor(N-N)` 1, `Pinpoint-StatStorageExecutor(N-N)` 1, `Pinpoint-deadlock-monitor` 1, `Pinpoint-metadata-timer(N-N)` 1, `Pinpoint-reconnect-thread(N-N)` 1, `Pinpoint-stat-monitor(N-N)` 1, `grpc-default-executor-N` 1
