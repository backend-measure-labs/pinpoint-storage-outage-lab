"""여러 회차를 단계별로 나란히 놓는다. 판정 지표만 고른다.

    .venv/bin/python scripts/compare.py reports/run-r1 reports/run-r2 > reports/compare.md
"""
import os
import statistics
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(__file__))
import analyze  # noqa: E402

MB = 1024 * 1024


def phase_rows(run):
    phases = analyze.read_events(run)
    samples = analyze.with_cpu_pct(analyze.read_probes(run))
    by_phase = defaultdict(list)
    for r in samples:
        p = analyze.phase_of(r["epoch_ms"], phases)
        if p:
            by_phase[p].append(r)
    return phases, by_phase, samples


def cell(rows, key, how, scale=1.0):
    vals = [r[key] * scale for r in rows if r.get(key) is not None]
    return analyze.summarize(vals, how)


def main(runs):
    data = {os.path.basename(os.path.normpath(r)): phase_rows(r) for r in runs}
    order = [name for name, _, _ in next(iter(data.values()))[0]]
    metrics = [
        ("RSS 중앙(MB)", lambda rows: cell(rows, "rss_kb", "median", 1 / 1024)),
        ("RSS 변화(MB)", lambda rows: analyze.drift(rows, "rss_kb", 1 / 1024)),
        ("NMT Thread 끝(MB)", lambda rows: cell(rows, "nmt_thread_kb", "last", 1 / 1024)),
        ("NMT Other 끝(MB)", lambda rows: cell(rows, "nmt_other_kb", "last", 1 / 1024)),
        ("스레드 최대", lambda rows: cell(rows, "threads", "max")),
        ("Tomcat 최대", lambda rows: cell(rows, "threads_tomcat", "max")),
        ("컬렉터 ESTAB 최대", lambda rows: cell(rows, "col_estab", "max")),
        ("컬렉터 SYN_SENT 최대", lambda rows: cell(rows, "col_syn_sent", "max")),
        ("받은 연결 최대", lambda rows: cell(rows, "inbound_estab", "max")),
        ("처리 중 최대", lambda rows: cell(rows, "req_peak_active", "max")),
        ("요청 평균(ms)", lambda rows: weighted_avg(rows)),
        ("요청 최대(ms)", lambda rows: cell(rows, "req_max_ms", "max")),
        ("오류", lambda rows: cell(rows, "req_errors", "sum")),
    ]
    names = list(data)
    print("값은 " + " / ".join(names) + " 순서다.\n")
    print("| 단계 | " + " | ".join(label for label, _ in metrics) + " |")
    print("|---|" + "---|" * len(metrics))
    for phase in order:
        if phase == "startup":
            continue
        cells = []
        for _, fn in metrics:
            vals = [fn(data[n][1][phase]) if data[n][1].get(phase) else None for n in names]
            cells.append(" / ".join(analyze.fmt(v) for v in vals))
        print(f"| {analyze.PHASE_LABEL.get(phase, phase)} | " + " | ".join(cells) + " |")


def weighted_avg(rows):
    n = sum(r["req_count"] for r in rows)
    return sum(r["req_avg_ms"] * r["req_count"] for r in rows) / n if n else None


if __name__ == "__main__":
    main(sys.argv[1:])
