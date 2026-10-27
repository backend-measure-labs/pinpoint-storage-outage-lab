package lab.probe;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.LongAccumulator;
import java.util.concurrent.atomic.LongAdder;

/**
 * 프로브 표본 사이(2초)에 끝난 요청의 수 · 평균 · 최대 처리 시간과 지금 처리 중인 요청 수.
 * 에이전트가 요청 스레드를 붙잡으면 처리 시간과 처리 중 요청이 함께 오른다.
 * 100ms 칸마다 들어온 요청 수의 최대도 남긴다. 지연이 튈 때 요청이 몰려 들어왔는지(부하 쪽),
 * 고르게 들어왔는데 처리가 늦었는지(앱 쪽)를 나눈다.
 */
@Component
public class RequestStats extends OncePerRequestFilter {

    private final LongAdder count = new LongAdder();
    private final LongAdder errors = new LongAdder();
    private final LongAdder totalMicros = new LongAdder();
    private final LongAccumulator maxMicros = new LongAccumulator(Math::max, 0);
    private final AtomicInteger active = new AtomicInteger();
    private final AtomicLong peakActive = new AtomicLong();
    private long arrivalBucket;
    private int arrivalsInBucket;
    private int peakArrivals;

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return request.getRequestURI().startsWith("/probe");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        long start = System.nanoTime();
        countArrival(start / 100_000_000);
        peakActive.accumulateAndGet(active.incrementAndGet(), Math::max);
        try {
            chain.doFilter(request, response);
        } catch (IOException | ServletException | RuntimeException e) {
            errors.increment();
            throw e;
        } finally {
            active.decrementAndGet();
            long micros = (System.nanoTime() - start) / 1000;
            count.increment();
            totalMicros.add(micros);
            maxMicros.accumulate(micros);
            if (response.getStatus() >= 500) {
                errors.increment();
            }
        }
    }

    private synchronized void countArrival(long bucket) {
        if (bucket != arrivalBucket) {
            arrivalBucket = bucket;
            arrivalsInBucket = 0;
        }
        peakArrivals = Math.max(peakArrivals, ++arrivalsInBucket);
    }

    private synchronized int drainPeakArrivals() {
        int peak = peakArrivals;
        peakArrivals = 0;
        return peak;
    }

    /** 표본 하나를 꺼내고 구간 값을 비운다. */
    Window drain() {
        long n = count.sumThenReset();
        long total = totalMicros.sumThenReset();
        long max = maxMicros.getThenReset();
        long peak = peakActive.getAndSet(active.get());
        return new Window(n, errors.sumThenReset(), n == 0 ? 0 : total / n / 1000.0, max / 1000.0, peak,
                drainPeakArrivals());
    }

    record Window(long count, long errors, double avgMs, double maxMs, long peakActive, int peakArrivals100ms) {
    }
}
