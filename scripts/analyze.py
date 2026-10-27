"""회차 하나를 단계별로 집계한다.

    .venv/bin/python scripts/analyze.py reports/run-<시각>

같은 디렉토리에 summary.md 와 timeline.png 를 남긴다.
"""
import csv
import glob
import gzip
import json
import os
import re
import statistics
import sys
from collections import Counter, defaultdict
from datetime import datetime, timezone

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

MB = 1024 * 1024
PHASE_LABEL = {
    "startup": "기동",
    "normal": "정상",
    "restart_normal": "정상 중 재기동",
    "collector_down": "컬렉터 다운",
    "restart_collector_down": "컬렉터 다운 중 재기동",
    "collector_down_recover": "컬렉터 복구",
    "collector_unresponsive": "컬렉터 응답 없음",
    "restart_collector_unresponsive": "컬렉터 응답 없음 중 재기동",
    "collector_unresponsive_recover": "컬렉터 응답 복구",
    "hbase_lock_timeout": "HBase 락 타임아웃",
    "restart_hbase_lock_timeout": "HBase 락 타임아웃 중 재기동",
    "hbase_lock_timeout_recover": "HBase 락 타임아웃 해제",
    "hbase_down": "HBase 다운",
    "restart_hbase_down": "HBase 다운 중 재기동",
    "hbase_down_recover": "HBase 복구",
}


def read_events(run):
    with open(os.path.join(run, "events.csv")) as f:
        rows = [(int(ts), name) for ts, name in csv.reader(f)]
    phases = []
    for (start, name), (end, _) in zip(rows, rows[1:]):
        phases.append((name, start, end))
    return phases


def phase_of(ts, phases):
    for name, start, end in phases:
        if start <= ts < end:
            return name
    return None


def clock_offset(run):
    """VM 시계 - 호스트 시계(ms). 프로브 시각에서 빼면 단계 표시와 같은 시계가 된다."""
    path = os.path.join(run, "clock.csv")
    if not os.path.exists(path):
        return 0
    with open(path) as f:
        diffs = [int(v) - int(h) for h, v in csv.reader(f)]
    return statistics.fmean(diffs)


def read_probes(run):
    """앱 파드 로그의 PROBE 줄. 파드 이름을 붙이고 시각을 호스트 시계로 맞춘다."""
    offset = clock_offset(run)
    samples = []
    for path in sorted(glob.glob(os.path.join(run, "app-*.log*"))):
        pod = os.path.basename(path)[4:].split(".log")[0]
        header = None
        opener = gzip.open if path.endswith(".gz") else open
        with opener(path, "rt", errors="replace") as f:
            for line in f:
                if not line.startswith("PROBE,"):
                    continue
                cols = line.strip().split(",")
                if cols[1] == "epoch_ms":
                    header = cols[1:]
                    # 두 회차 이미지는 헤더 끝의 두 이름이 빠진 채 값만 찍었다 (값의 순서는 같다)
                    if header[-1] == "jvm_start_ms":
                        header += ["threads_tomcat", "req_peak_arrivals_100ms"]
                    continue
                if header is None or len(cols) - 1 != len(header):
                    continue
                row = {k: float(v) for k, v in zip(header, cols[1:])}
                row["epoch_ms"] -= offset
                row["jvm_start_ms"] = row.get("jvm_start_ms", 0) - offset
                row["pod"] = pod
                samples.append(row)
    samples.sort(key=lambda r: r["epoch_ms"])
    return samples


def with_cpu_pct(samples):
    """누적 CPU 시간의 차분을 코어 대비 % 로 바꾼다. 파드가 바뀌면 이어 붙이지 않는다."""
    last = {}
    for r in samples:
        prev = last.get(r["pod"])
        if prev and r["epoch_ms"] > prev["epoch_ms"]:
            r["cpu_pct"] = (r["cpu_ms"] - prev["cpu_ms"]) / (r["epoch_ms"] - prev["epoch_ms"]) * 100
        else:
            r["cpu_pct"] = None
        last[r["pod"]] = r
    return samples


def read_containers(run):
    rows = []
    path = os.path.join(run, "containers.csv")
    if not os.path.exists(path):
        return rows
    with open(path) as f:
        for r in csv.DictReader(f):
            try:
                rows.append({"epoch_ms": int(r["epoch_ms"]), "container": r["container"],
                             "cpu_pct": float(r["cpu_pct"]), "mem_mb": to_mb(r["mem"])})
            except (ValueError, KeyError, TypeError):
                continue
    return rows


def to_mb(text):
    m = re.match(r"([\d.]+)\s*([KMG]i?B|B)", text.strip())
    if not m:
        raise ValueError(text)
    value, unit = float(m.group(1)), m.group(2)
    return value * {"B": 1 / MB, "KiB": 1 / 1024, "MiB": 1, "GiB": 1024, "KB": 1 / 1024, "MB": 1, "GB": 1024}[unit]


def read_pods(run):
    with open(os.path.join(run, "pods.csv")) as f:
        return [(int(ts), pod) for ts, pod in csv.reader(f)]


LOG_LINE = re.compile(r"^(\d\d-\d\d \d\d:\d\d:\d\d\.\d{3})\s+(?:\[[^\]]*\]\s+)?(WARN|ERROR)\s+(\S+)\s*:?\s*(.*)$")


def log_events(paths, year, offset):
    """핀포인트 로그 형식(MM-dd HH:mm:ss.SSS 레벨 로거 : 메시지)의 WARN · ERROR 줄. 시각은 호스트 시계로 맞춘다."""
    out = []
    for path in paths:
        opener = gzip.open if path.endswith(".gz") else open
        with opener(path, "rt", errors="replace") as f:
            for line in f:
                m = LOG_LINE.match(line)
                if not m:
                    continue
                ts = datetime.strptime(f"{year}-{m.group(1)}", "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=timezone.utc)
                message = re.sub(r"\d+", "N", m.group(4))[:110]
                out.append((int(ts.timestamp() * 1000 - offset), m.group(2), m.group(3), message))
    return out


def summarize(values, how):
    values = [v for v in values if v is not None]
    if not values:
        return None
    return {"max": max, "min": min, "last": lambda v: v[-1], "first": lambda v: v[0],
            "mean": statistics.fmean, "median": statistics.median, "sum": sum}[how](values)


def fmt(v, digits=1):
    if v is None:
        return "-"
    if isinstance(v, float) and not v.is_integer():
        return f"{v:,.{digits}f}"
    return f"{int(v):,}"


def drift(rows, key, scale=1.0):
    """단계 첫 1분 평균과 마지막 1분 평균의 차. 쌓이는지 보는 값."""
    if len(rows) < 4:
        return None
    t0, t1 = rows[0]["epoch_ms"], rows[-1]["epoch_ms"]
    if t1 - t0 < 150_000:
        return None
    head = [r[key] for r in rows if r["epoch_ms"] < t0 + 60_000]
    tail = [r[key] for r in rows if r["epoch_ms"] > t1 - 60_000]
    return (statistics.fmean(tail) - statistics.fmean(head)) * scale


def main(run):
    phases = read_events(run)
    samples = with_cpu_pct(read_probes(run))
    containers = read_containers(run)
    pods = read_pods(run)
    year = datetime.fromtimestamp(phases[0][1] / 1000, timezone.utc).year
    by_phase = defaultdict(list)
    for r in samples:
        p = phase_of(r["epoch_ms"], phases)
        if p:
            by_phase[p].append(r)

    lines = [f"# {os.path.basename(run)}", ""]
    with open(os.path.join(run, "env.txt")) as f:
        lines += ["```", f.read().strip(), "```", ""]

    lines += ["## 단계별 앱 자원", "",
              "| 단계 | 시간(s) | RSS 중앙 · 최대(MB) | RSS 변화(MB) | 힙 최저(MB) | NMT Other 끝(MB) | NMT Thread 끝(MB) "
              "| 스레드 최대 (핀포인트 · Tomcat) | 컬렉터 연결 ESTAB · SYN_SENT · TIME_WAIT 최대 | 받은 연결 최대 | fd 최대 | CPU 평균(%) "
              "| 요청 평균 · 최대(ms) | 처리 중 최대 | 100ms 도착 최대 | 오류 |",
              "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for name, start, end in phases:
        rows = by_phase.get(name, [])
        if not rows:
            lines.append(f"| {PHASE_LABEL.get(name, name)} | {(end - start) // 1000} | 프로브 없음 |||||||||||||")
            continue
        req_n = sum(r["req_count"] for r in rows)
        req_avg = sum(r["req_avg_ms"] * r["req_count"] for r in rows) / req_n if req_n else None
        lines.append("| " + " | ".join([
            PHASE_LABEL.get(name, name),
            str((end - start) // 1000),
            f"{fmt(summarize([r['rss_kb'] / 1024 for r in rows], 'median'))} · {fmt(summarize([r['rss_kb'] / 1024 for r in rows], 'max'))}",
            fmt(drift(rows, "rss_kb", 1 / 1024)),
            fmt(summarize([r["heap_used"] / MB for r in rows], "min")),
            fmt(summarize([r["nmt_other_kb"] / 1024 for r in rows], "last")),
            fmt(summarize([r["nmt_thread_kb"] / 1024 for r in rows], "last")),
            f"{fmt(summarize([r['threads'] for r in rows], 'max'))} ({fmt(summarize([r['threads_pinpoint'] for r in rows], 'max'))} · {fmt(summarize([r['threads_tomcat'] for r in rows], 'max'))})",
            " · ".join(fmt(summarize([r[k] for r in rows], "max")) for k in ("col_estab", "col_syn_sent", "col_time_wait")),
            fmt(summarize([r["inbound_estab"] for r in rows], "max")),
            fmt(summarize([r["fds"] for r in rows], "max")),
            fmt(summarize([r["cpu_pct"] for r in rows], "mean")),
            f"{fmt(req_avg, 2)} · {fmt(summarize([r['req_max_ms'] for r in rows], 'max'), 1)}",
            fmt(summarize([r["req_peak_active"] for r in rows], "max")),
            fmt(summarize([r["req_peak_arrivals_100ms"] for r in rows], "max")),
            fmt(summarize([r["req_errors"] for r in rows], "sum")),
        ]) + " |")

    lines += ["", "## 기동", "",
              "JVM 시작 시각(RuntimeMXBean)부터 잰다. 기동 CPU 는 첫 프로브 표본의 누적 프로세스 CPU 시간이다 (스프링 기동 완료 직후).", "",
              "| 시작 단계 | 첫 프로브까지(s) | 기동 CPU(s) | 첫 프로브 RSS(MB) | 120초 안 RSS 최대(MB) | 120초 안 스레드 최대 | 120초 안 컬렉터 연결 최대 ESTAB · SYN_SENT · TIME_WAIT | 120초 안 CPU 최대(%) |",
              "|---|---|---|---|---|---|---|---|"]
    for _, pod in pods:
        mine = [r for r in samples if r["pod"] == pod]
        if not mine:
            continue
        first = mine[0]
        start = first["jvm_start_ms"]
        window = [r for r in mine if r["epoch_ms"] < start + 120_000]
        lines.append("| " + " | ".join([
            PHASE_LABEL.get(phase_of(int(start), phases) or ("startup" if start < phases[0][1] else None), "-"),
            fmt((first["epoch_ms"] - start) / 1000), fmt(first["cpu_ms"] / 1000, 2),
            fmt(first["rss_kb"] / 1024), fmt(summarize([r["rss_kb"] / 1024 for r in window], "max")),
            fmt(summarize([r["threads"] for r in window], "max")),
            " · ".join(fmt(summarize([r[k] for r in window], "max")) for k in ("col_estab", "col_syn_sent", "col_time_wait")),
            fmt(summarize([r["cpu_pct"] for r in window], "max")),
        ]) + " |")

    lines += ["", "## 서버 컨테이너 메모리 (단계 끝 값, MB)", "", "| 단계 | 컬렉터 | HBase | ZooKeeper |", "|---|---|---|---|"]
    for name, start, end in phases:
        cells = []
        for c in ("collector", "hbase", "zookeeper"):
            vals = [x["mem_mb"] for x in containers if x["container"] == c and start <= x["epoch_ms"] < end]
            cells.append(fmt(vals[-1]) if vals else "-")
        lines.append(f"| {PHASE_LABEL.get(name, name)} | " + " | ".join(cells) + " |")

    for title, pattern in (("에이전트 로그 (앱 파드)", "app-*.log*"), ("컬렉터 로그", "collector-*.log*")):
        events = log_events(sorted(glob.glob(os.path.join(run, pattern))), year, clock_offset(run))
        lines += ["", f"## {title} WARN · ERROR", "", "| 단계 | 레벨 | 로거 | 메시지 (숫자는 N) | 건수 |", "|---|---|---|---|---|"]
        counts = Counter((phase_of(ts, phases), lvl, logger, msg) for ts, lvl, logger, msg in events)
        order = {name: i for i, (name, _, _) in enumerate(phases)}
        # 단계마다 많은 순으로 10줄. 전체에서 자르면 뒤 단계가 통째로 빠진다.
        shown = Counter()
        for (p, lvl, logger, msg), n in sorted(counts.items(), key=lambda kv: (order.get(kv[0][0], 99), -kv[1])):
            shown[p] += 1
            if shown[p] > 10:
                continue
            lines.append(f"| {PHASE_LABEL.get(p, p or '-')} | {lvl} | {logger} | {msg.replace('|', '/')} | {n} |")
        totals = Counter(phase_of(ts, phases) for ts, _, _, _ in events)
        lines += ["", "| 단계 | WARN · ERROR 전체 건수 |", "|---|---|"]
        for name, _, _ in phases:
            lines.append(f"| {PHASE_LABEL.get(name, name)} | {totals.get(name, 0)} |")

    lines += ["", "## 단계 끝 스레드 (이름별, 핀포인트 · gRPC 만)", ""]
    for name, _, _ in phases:
        path = os.path.join(run, f"threads-{name}.json")
        if not os.path.exists(path) or os.path.getsize(path) == 0:
            continue
        with open(path) as f:
            groups = json.load(f)
        picked = {k: v for k, v in groups.items() if "inpoint" in k or "grpc" in k.lower()}
        lines.append(f"- {PHASE_LABEL.get(name, name)}: 전체 {sum(groups.values())} · "
                     + ", ".join(f"`{k}` {v}" for k, v in sorted(picked.items(), key=lambda kv: -kv[1])))

    with open(os.path.join(run, "summary.md"), "w") as f:
        f.write("\n".join(lines) + "\n")
    plot(run, phases, samples, containers)
    print(os.path.join(run, "summary.md"))


def plot(run, phases, samples, containers):
    plt.rcParams["font.family"] = ["AppleGothic", "NanumGothic", "DejaVu Sans"]
    t0 = phases[0][1]
    series = [
        ("RSS (MB)", lambda r: r["rss_kb"] / 1024),
        ("힙 사용 (MB)", lambda r: r["heap_used"] / MB),
        ("NMT Other (MB)", lambda r: r["nmt_other_kb"] / 1024),
        ("스레드 (전체)", lambda r: r["threads"]),
        ("Tomcat 작업 스레드", lambda r: r["threads_tomcat"]),
        ("컬렉터 연결 ESTAB", lambda r: r["col_estab"]),
        ("CPU (%)", lambda r: r["cpu_pct"]),
        ("요청 최대 (ms)", lambda r: r["req_max_ms"]),
    ]
    fig, axes = plt.subplots(len(series) + 1, 1, figsize=(14, 2.1 * (len(series) + 1)), sharex=True)
    for ax, (title, fn) in zip(axes, series):
        for pod in dict.fromkeys(r["pod"] for r in samples):
            pts = [((r["epoch_ms"] - t0) / 60000, fn(r)) for r in samples if r["pod"] == pod and fn(r) is not None]
            ax.plot([p[0] for p in pts], [p[1] for p in pts], lw=0.9)
        ax.set_ylabel(title, fontsize=8)
    ax = axes[-1]
    for c in ("collector", "hbase"):
        pts = [((x["epoch_ms"] - t0) / 60000, x["mem_mb"]) for x in containers if x["container"] == c]
        ax.plot([p[0] for p in pts], [p[1] for p in pts], lw=0.9, label=c)
    ax.set_ylabel("서버 메모리 (MB)", fontsize=8)
    ax.legend(fontsize=7)
    for ax in axes:
        for i, (name, start, end) in enumerate(phases):
            if i % 2:
                ax.axvspan((start - t0) / 60000, (end - t0) / 60000, color="0.92", lw=0)
    for name, start, _ in phases:
        axes[0].text((start - t0) / 60000, axes[0].get_ylim()[1], PHASE_LABEL.get(name, name), fontsize=6, rotation=30, va="bottom")
    axes[-1].set_xlabel("경과 (분)")
    fig.tight_layout()
    fig.savefig(os.path.join(run, "timeline.png"), dpi=110)


if __name__ == "__main__":
    main(sys.argv[1])
