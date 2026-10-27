package lab.probe;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.lang.management.BufferPoolMXBean;
import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * 2초마다 앱 자신의 자원을 한 줄(PROBE,...)로 표준 출력에 남긴다.
 * 바깥에서 jstat · jcmd 를 주기적으로 띄우면 그 JVM 기동 비용이 CPU 측정에 섞이므로 같은 프로세스 안에서 읽는다.
 */
@Component
public class ResourceProbe {

    static final String HEADER = "PROBE,epoch_ms,heap_used,heap_committed,nonheap_used,direct_used,direct_count,"
            + "threads,threads_pinpoint,threads_grpc,rss_kb,cgroup_mem,cgroup_anon,cpu_ms,gc_count,gc_ms,fds,"
            + "col_estab,col_syn_sent,col_time_wait,col_close_wait,col_other,inbound_estab,tcp_total,"
            + "req_count,req_errors,req_avg_ms,req_max_ms,req_peak_active,"
            + "nmt_total_kb,nmt_heap_kb,nmt_class_kb,nmt_thread_kb,nmt_code_kb,nmt_gc_kb,nmt_internal_kb,nmt_other_kb,jvm_start_ms,threads_tomcat,req_peak_arrivals_100ms";

    private final MemoryMXBean memory = ManagementFactory.getMemoryMXBean();
    private final com.sun.management.OperatingSystemMXBean os =
            (com.sun.management.OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
    private final List<GarbageCollectorMXBean> gcs = ManagementFactory.getGarbageCollectorMXBeans();
    private final BufferPoolMXBean direct = ManagementFactory.getPlatformMXBeans(BufferPoolMXBean.class).stream()
            .filter(p -> p.getName().equals("direct")).findFirst().orElseThrow();
    private final RequestStats requests;
    private boolean headerPrinted;

    public ResourceProbe(RequestStats requests) {
        this.requests = requests;
    }

    @Scheduled(fixedRate = 2000)
    public void sample() {
        if (!headerPrinted) {
            System.out.println(HEADER);
            headerPrinted = true;
        }
        ThreadCounts threads = ThreadCounts.now();
        TcpCounts tcp = TcpCounts.read();
        long gcCount = gcs.stream().mapToLong(GarbageCollectorMXBean::getCollectionCount).sum();
        long gcMs = gcs.stream().mapToLong(GarbageCollectorMXBean::getCollectionTime).sum();
        RequestStats.Window window = requests.drain();
        java.util.Map<String, Long> nmt = NativeMemory.committedKb();
        System.out.println(String.join(",", "PROBE",
                Long.toString(System.currentTimeMillis()),
                Long.toString(memory.getHeapMemoryUsage().getUsed()),
                Long.toString(memory.getHeapMemoryUsage().getCommitted()),
                Long.toString(memory.getNonHeapMemoryUsage().getUsed()),
                Long.toString(direct.getMemoryUsed()),
                Long.toString(direct.getCount()),
                Integer.toString(threads.total()),
                Integer.toString(threads.pinpoint()),
                Integer.toString(threads.grpc()),
                Long.toString(statusKb("VmRSS")),
                Long.toString(cgroupMemory()),
                Long.toString(cgroupAnon()),
                Long.toString(os.getProcessCpuTime() / 1_000_000),
                Long.toString(gcCount),
                Long.toString(gcMs),
                Integer.toString(fdCount()),
                Integer.toString(tcp.estab()),
                Integer.toString(tcp.synSent()),
                Integer.toString(tcp.timeWait()),
                Integer.toString(tcp.closeWait()),
                Integer.toString(tcp.other()),
                Integer.toString(tcp.inbound()),
                Integer.toString(tcp.total()),
                Long.toString(window.count()),
                Long.toString(window.errors()),
                String.format("%.2f", window.avgMs()),
                String.format("%.2f", window.maxMs()),
                Long.toString(window.peakActive()),
                Long.toString(nmt.getOrDefault("Total", -1L)),
                Long.toString(nmt.getOrDefault("Java Heap", -1L)),
                Long.toString(nmt.getOrDefault("Class", -1L)),
                Long.toString(nmt.getOrDefault("Thread", -1L)),
                Long.toString(nmt.getOrDefault("Code", -1L)),
                Long.toString(nmt.getOrDefault("GC", -1L)),
                Long.toString(nmt.getOrDefault("Internal", -1L)),
                Long.toString(nmt.getOrDefault("Other", -1L)),
                Long.toString(ManagementFactory.getRuntimeMXBean().getStartTime()),
                Integer.toString(threads.tomcat()),
                Integer.toString(window.peakArrivals100ms())));
    }

    static long statusKb(String key) {
        try {
            for (String line : Files.readAllLines(Path.of("/proc/self/status"))) {
                if (line.startsWith(key + ":")) {
                    return Long.parseLong(line.replaceAll("[^0-9]", ""));
                }
            }
        } catch (IOException ignored) {
            // 리눅스가 아닌 곳에서 띄우면 없다
        }
        return -1;
    }

    /** cgroup v2 의 memory.current. 쿠버네티스가 컨테이너 메모리로 보는 값의 바탕이다. */
    static long cgroupMemory() {
        return readLong("/sys/fs/cgroup/memory.current", "/sys/fs/cgroup/memory/memory.usage_in_bytes");
    }

    /** 페이지 캐시를 뺀 익명 메모리. 회수할 수 없는 쪽이라 노드 압박의 실체에 가깝다. */
    static long cgroupAnon() {
        for (String file : List.of("/sys/fs/cgroup/memory.stat", "/sys/fs/cgroup/memory/memory.stat")) {
            try {
                for (String line : Files.readAllLines(Path.of(file))) {
                    if (line.startsWith("anon ") || line.startsWith("rss ")) {
                        return Long.parseLong(line.split(" ")[1]);
                    }
                }
            } catch (IOException ignored) {
                // 다음 경로를 본다
            }
        }
        return -1;
    }

    private static long readLong(String... files) {
        for (String file : files) {
            try {
                return Long.parseLong(Files.readString(Path.of(file)).trim());
            } catch (IOException | NumberFormatException ignored) {
                // 다음 경로를 본다
            }
        }
        return -1;
    }

    private static int fdCount() {
        String[] fds = new File("/proc/self/fd").list();
        return fds == null ? -1 : fds.length;
    }
}
