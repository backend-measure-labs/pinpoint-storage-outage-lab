package lab.probe;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/** 단계가 끝날 때 실행 스크립트가 부르는 스냅샷. 네이티브 메모리 구역별 크기와 스레드 이름별 개수. */
@RestController
public class ProbeController {

    @GetMapping(value = "/probe/nmt", produces = "text/plain")
    public String nativeMemory() {
        return NativeMemory.summary();
    }

    @GetMapping("/probe/threads")
    public Map<String, Integer> threads() {
        return ThreadCounts.byName();
    }
}
