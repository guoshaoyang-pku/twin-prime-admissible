#!/usr/bin/env python3
"""用算法 C 搜索 H(k) 精确值 (k=20..42): 从 2(k-1) 递增找第一个 SAT"""
import sys, time
sys.path.insert(0, '.')
from cert_gen import gen_cert, primes_upto

def H_of(k, d_start, d_max=400):
    d = d_start
    while d <= d_max:
        root, _ = gen_cert(k, d)
        if root is None:
            return d  # 第一个 SAT
        d += 2
    return None

for k in range(20, 43):
    t0 = time.time()
    H = H_of(k, 2 * (k - 1))
    dt = time.time() - t0
    print(f"H({k}) = {H}   ({dt:.1f}s)", flush=True)
