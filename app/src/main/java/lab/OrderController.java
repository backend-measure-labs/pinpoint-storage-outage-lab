package lab;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

/**
 * 트레이스 한 건이 들어오는 요청 · 나가는 HTTP 호출 · 메서드 몇 개로 이루어지도록 만든 업무 흉내.
 * 주문 조회가 재고 조회를 HTTP 로 부르므로 요청 1건이 스팬 2개(주문 · 재고)를 만든다.
 */
@RestController
public class OrderController {

    private final RestTemplate restTemplate;
    private final String downstream;

    public OrderController(RestTemplate restTemplate, @Value("${lab.downstream}") String downstream) {
        this.restTemplate = restTemplate;
        this.downstream = downstream;
    }

    @GetMapping("/orders/{id}")
    public Map<String, Object> order(@PathVariable long id) {
        Map<?, ?> stock = restTemplate.getForObject(downstream + "/stock/" + id, Map.class);
        return Map.of("id", id, "checksum", checksum(id), "stock", stock);
    }

    @GetMapping("/stock/{id}")
    public Map<String, Object> stock(@PathVariable long id) throws InterruptedException {
        Thread.sleep(5);
        return Map.of("id", id, "left", id % 17);
    }

    private long checksum(long seed) {
        long v = seed;
        for (int i = 0; i < 20_000; i++) {
            v = v * 31 + i;
        }
        return v;
    }
}
