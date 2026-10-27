package lab.probe;

import javax.management.ObjectName;
import java.lang.management.ManagementFactory;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * NMT(-XX:NativeMemoryTracking=summary) 요약에서 구역별 committed 값을 읽는다.
 * gRPC 전송의 네티는 직접 메모리를 Unsafe 로 잡아 BufferPoolMXBean 에 보이지 않고 NMT 의 Other 에 잡힌다.
 */
final class NativeMemory {

    private static final Pattern SECTION = Pattern.compile("-\\s+([A-Za-z ]+?) \\(reserved=\\d+KB, committed=(\\d+)KB\\)");
    private static final Pattern TOTAL = Pattern.compile("Total: reserved=\\d+KB, committed=(\\d+)KB");

    private NativeMemory() {
    }

    static String summary() {
        try {
            return (String) ManagementFactory.getPlatformMBeanServer().invoke(
                    new ObjectName("com.sun.management:type=DiagnosticCommand"),
                    "vmNativeMemory",
                    new Object[]{new String[]{"summary"}},
                    new String[]{String[].class.getName()});
        } catch (Exception e) {
            return "";
        }
    }

    /** 구역 이름 → committed KB. 전체는 Total 로 담는다. */
    static Map<String, Long> committedKb() {
        String text = summary();
        Map<String, Long> sections = new TreeMap<>();
        Matcher total = TOTAL.matcher(text);
        if (total.find()) {
            sections.put("Total", Long.parseLong(total.group(1)));
        }
        Matcher m = SECTION.matcher(text);
        while (m.find()) {
            sections.put(m.group(1).trim(), Long.parseLong(m.group(2)));
        }
        return sections;
    }
}
