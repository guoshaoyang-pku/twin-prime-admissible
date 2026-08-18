#!/usr/bin/env python3
"""每 5 分钟统计 319 目标 OK 数与各层 pending, 追加到 final_progress.log"""
import os, time
from collections import defaultdict

TARGETS = []
for _k, _H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        TARGETS.append((_k, _d))
TS = set(TARGETS)

def bucket(path):
    b = defaultdict(set)
    with open(path) as f:
        for line in f:
            p = tuple(map(int, line.split()))
            if p[:2] in TS:
                b[p[:2]].add(p)
    return b

def done_bucket(d):
    b = defaultdict(set)
    for fn in os.listdir(d):
        if os.path.getsize(os.path.join(d, fn)) > 0:
            p = tuple(map(int, fn[2:-4].split('_')))
            if p[:2] in TS:
                b[p[:2]].add(p)
    return b

def snapshot():
    T2 = bucket('par2_tasks.txt');  D2 = done_bucket('par2_results')
    R2 = bucket('par2rest_tasks.txt'); RD2 = done_bucket('par2rest_results')
    T3 = bucket('par3_tasks.txt');  D3 = done_bucket('par3_results')
    R3 = bucket('par2rest_par3_tasks.txt'); RD3 = done_bucket('par2rest_par3_results')
    T4 = bucket('par4_tasks.txt');  D4 = done_bucket('par4_results')
    T5 = bucket('par5_tasks.txt');  D5 = done_bucket('par5_results')
    T6 = bucket('par6_tasks.txt');  D6 = done_bucket('par6_results')
    bad = []
    for kd in sorted(TS):
        P3 = {t[:4] for t in T3[kd] | R3[kd]}
        P4 = {t[:5] for t in T4[kd]}
        P5 = {t[:6] for t in T5[kd]}
        P6 = {t[:7] for t in T6[kd]}
        p2 = [x for x in T2[kd] | R2[kd] if x not in D2[kd] | RD2[kd] and x not in P3]
        p3 = [x for x in T3[kd] | R3[kd] if x not in D3[kd] | RD3[kd] and x not in P4]
        p4 = [x for x in T4[kd] if x not in D4[kd] and x not in P5]
        p5 = [x for x in T5[kd] if x not in D5[kd] and x not in P6]
        p6 = [x for x in T6[kd] if x not in D6[kd]]
        n = len(p2)+len(p3)+len(p4)+len(p5)+len(p6)
        if n:
            bad.append((kd, len(p2), len(p3), len(p4), len(p5), len(p6)))
    return bad

while True:
    try:
        bad = snapshot()
        ok = 319 - len(bad)
        tot = sum(sum(b[1:]) for b in bad)
        line = f"{time.strftime('%m-%d %H:%M:%S')} OK={ok}/319 pending={tot}"
        for kd, a,b,c,d,e in bad:
            line += f" | {kd}:p4={c},p5={d},p6={e}"
        print(line, flush=True)
        with open('final_progress.log', 'a') as f:
            f.write(line + '\n')
        if ok == 319:
            print("ALL 319 DONE", flush=True)
            break
    except Exception as ex:
        print(f"ERR {ex}", flush=True)
    time.sleep(300)
