package lab.probe;

import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

/**
 * 스레드를 이름으로 나눠 센다. 핀포인트 에이전트 스레드는 이름에 Pinpoint 가, gRPC 전송 스레드는 grpc 가 들어간다.
 * Tomcat 요청 작업자는 http-nio-...-exec- 이다.
 */
record ThreadCounts(int total, int pinpoint, int grpc, int tomcat) {

    static ThreadCounts now() {
        int total = 0;
        int pinpoint = 0;
        int grpc = 0;
        int tomcat = 0;
        for (Thread t : Thread.getAllStackTraces().keySet()) {
            total++;
            String name = t.getName().toLowerCase(Locale.ROOT);
            if (name.contains("pinpoint")) {
                pinpoint++;
            }
            if (name.contains("grpc")) {
                grpc++;
            }
            if (name.startsWith("http-nio-") && name.contains("-exec-")) {
                tomcat++;
            }
        }
        return new ThreadCounts(total, pinpoint, grpc, tomcat);
    }

    /** 이름의 숫자를 지워 같은 풀의 스레드를 한 줄로 묶는다. */
    static Map<String, Integer> byName() {
        Map<String, Integer> groups = new TreeMap<>();
        for (Thread t : Thread.getAllStackTraces().keySet()) {
            groups.merge(t.getName().replaceAll("[0-9]+", "N"), 1, Integer::sum);
        }
        return groups;
    }
}
