#!/usr/bin/env python3
"""对全部 319 个 UNSAT 目标生成证书并验证"""
import sys, time
sys.path.insert(0, '.')
from cert_gen import gen_cert, serialize, verify

TARGETS = []
for _k, _H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        TARGETS.append((_k, _d))
print(f"targets: {len(TARGETS)}", flush=True)

t0 = time.time()
total_nodes = 0
total_bytes = 0
max_nodes = (0, None)
import os
os.makedirs('certs', exist_ok=True)
for i, (k, d) in enumerate(TARGETS):
    t1 = time.time()
    root, stats = gen_cert(k, d)
    if root is None:
        print(f"!!! SAT at k={k} d={d} — 反例!", flush=True)
        sys.exit(1)
    txt = serialize(root)
    assert verify(txt, k, d), f"verify failed k={k} d={d}"
    with open(f'certs/cert_{k}_{d}.txt', 'w') as f:
        f.write(txt)
    total_nodes += stats['nodes']
    total_bytes += len(txt)
    if stats['nodes'] > max_nodes[0]:
        max_nodes = (stats['nodes'], (k, d))
    if (i + 1) % 40 == 0:
        print(f"  {i+1}/{len(TARGETS)} done, {time.time()-t0:.0f}s, "
              f"total_nodes={total_nodes}", flush=True)
print(f"ALL {len(TARGETS)} DONE in {time.time()-t0:.0f}s", flush=True)
print(f"total_nodes={total_nodes} total_cert_bytes={total_bytes}", flush=True)
print(f"max_nodes={max_nodes[0]} at {max_nodes[1]}", flush=True)
