package lab.probe;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * 파드 네트워크 네임스페이스의 TCP 소켓을 /proc/net/tcp(6) 에서 읽어 센다.
 * 컬렉터 gRPC 포트(9991 에이전트 · 9992 통계 · 9993 스팬)로 가는 소켓은 상태별로 나누고,
 * 앱이 받은 연결(로컬 8080 의 ESTABLISHED)은 따로 센다.
 */
record TcpCounts(int estab, int synSent, int timeWait, int closeWait, int other, int inbound, int total) {

    private static final int APP_PORT = 8080;

    private static final List<Integer> COLLECTOR_PORTS = List.of(9991, 9992, 9993);

    static TcpCounts read() {
        int estab = 0;
        int synSent = 0;
        int timeWait = 0;
        int closeWait = 0;
        int other = 0;
        int inbound = 0;
        int total = 0;
        for (String file : List.of("/proc/net/tcp", "/proc/net/tcp6")) {
            List<String> lines;
            try {
                lines = Files.readAllLines(Path.of(file));
            } catch (IOException e) {
                continue;
            }
            for (String line : lines.subList(Math.min(1, lines.size()), lines.size())) {
                String[] cols = line.trim().split("\\s+");
                if (cols.length < 4) {
                    continue;
                }
                total++;
                if (port(cols[1]) == APP_PORT && cols[3].equals("01")) {
                    inbound++;
                }
                String remote = cols[2];
                if (!COLLECTOR_PORTS.contains(port(remote))) {
                    continue;
                }
                switch (cols[3]) {
                    case "01" -> estab++;
                    case "02" -> synSent++;
                    case "06" -> timeWait++;
                    case "08" -> closeWait++;
                    default -> other++;
                }
            }
        }
        return new TcpCounts(estab, synSent, timeWait, closeWait, other, inbound, total);
    }

    private static int port(String hexAddress) {
        return Integer.parseInt(hexAddress.substring(hexAddress.indexOf(':') + 1), 16);
    }
}
