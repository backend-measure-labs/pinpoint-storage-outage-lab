"""NMT 상세의 스레드 스택 영역을 스레드 덤프의 스택 주소와 짝지어 스레드 이름별 커밋 크기를 낸다.

    python3 scripts/stack_attribution.py reports/stack-<ts>

NMT 상세는 스레드 스택마다 예약 영역 [시작-끝] 과 그 안의 커밋 조각을 준다.
Thread.print 는 스레드마다 헤더 끝 대괄호에 스택 안의 주소를 준다. 주소가 든 예약 영역이 그 스레드의 스택이다.

한계: 합계가 NMT summary 의 stack committed 보다 작게 나온다(2026-10-27 실측 5.2MB 대 7.2MB). 두 경우를 같은 방식으로
세어 차이를 보는 용도이고, 절대값은 summary 를 쓴다.
"""
import os
import re
import sys
from collections import defaultdict

RESERVED = re.compile(r"^\[(0x[0-9a-f]+) - (0x[0-9a-f]+)\] reserved (\d+)KB for Thread Stack")
COMMITTED = re.compile(r"^\s+\[(0x[0-9a-f]+) - (0x[0-9a-f]+)\] committed (\d+)KB")
REGION_END = re.compile(r"^\[0x[0-9a-f]+ - 0x[0-9a-f]+\] reserved")
THREAD = re.compile(r'^"(?P<name>[^"]+)".*\[(?P<addr>0x[0-9a-f]+)\]\s*$')


def stack_regions(path):
    regions, cur = [], None
    with open(path) as f:
        for line in f:
            m = RESERVED.match(line)
            if m:
                cur = {"start": int(m[1], 16), "end": int(m[2], 16), "reserved_kb": int(m[3]), "committed_kb": 0}
                regions.append(cur)
                continue
            if REGION_END.match(line):
                cur = None
                continue
            if cur is not None:
                m = COMMITTED.match(line)
                if m:
                    cur["committed_kb"] += int(m[3])
    return regions


def threads(path):
    out = []
    with open(path) as f:
        for line in f:
            m = THREAD.match(line)
            if m:
                out.append((m["name"], int(m["addr"], 16)))
    return out


def group(name):
    return re.sub(r"\d+", "N", name)


def attribute(run, case):
    regions = stack_regions(os.path.join(run, f"nmt-detail-{case}.txt"))
    named = defaultdict(lambda: [0, 0])
    matched = set()
    for name, addr in threads(os.path.join(run, f"threads-{case}.txt")):
        for i, r in enumerate(regions):
            if r["start"] <= addr < r["end"]:
                g = named[group(name)]
                g[0] += 1
                g[1] += r["committed_kb"]
                matched.add(i)
                break
    unmatched = [r for i, r in enumerate(regions) if i not in matched]
    named["(덤프에 주소 없음: VM 내부 · 네이티브 스레드)"] = [len(unmatched), sum(r["committed_kb"] for r in unmatched)]
    total = sum(r["committed_kb"] for r in regions)
    return named, total, len(regions)


def main(run):
    cases = ["normal_restart", "hbase_down_restart"]
    data = {c: attribute(run, c) for c in cases}
    for c in cases:
        _, total, n = data[c]
        print(f"- {c}: 스택 영역 {n}개, 커밋 합계 {total / 1024:.1f}MB")
    print()
    print("| 스레드 이름 | 정상 재기동 (개 / KB) | HBase 다운 중 재기동 (개 / KB) | 차이 KB |")
    print("|---|---|---|---|")
    names = set(data[cases[0]][0]) | set(data[cases[1]][0])
    rows = []
    for n in names:
        a = data[cases[0]][0].get(n, [0, 0])
        b = data[cases[1]][0].get(n, [0, 0])
        rows.append((b[1] - a[1], n, a, b))
    for diff, n, a, b in sorted(rows, key=lambda r: -abs(r[0])):
        print(f"| {n} | {a[0]} / {a[1]} | {b[0]} / {b[1]} | {diff:+d} |")


if __name__ == "__main__":
    main(sys.argv[1])
