#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""big_scan.py — 大 D 全空间数值 (对称多项式基 + numpy 广义特征值)
等价于 Polymath8b 的对称单项式基方法 (幂和基张成同一空间)。
用法: python3 big_scan.py k eps_num eps_den D [even] [r1,r2,...]
  even=1 时仅用偶数签名 (论文的速度技巧)
  r 列表 (默认 4,5,6,7) 扫描; 输出最优 M
"""
import sys, time
sys.path.insert(0, '.')
import math
import floatbuild as fb
from floatbuild import multiset_key, H_of_float, build_matrices_float, float_lambda_max

def gen_multisets_even(max_deg, max_parts):
    """偶数 part 的多重集 (非增, part ≥ 2 且偶), 总度数 ≤ max_deg"""
    res = []
    def rec(deg_used, parts):
        res.append((tuple(sorted(parts, reverse=True)), sum(parts)))
        for v in range(2, max_deg - deg_used + 1, 2):
            if len(parts) < max_parts:
                rec(deg_used + v, parts + [v])
    rec(0, [])
    return dict(res)

def gen_multisets(max_deg, max_parts):
    res = []
    def rec(deg_used, parts):
        res.append((tuple(sorted(parts, reverse=True)), sum(parts)))
        for v in range(1, max_deg - deg_used + 1):
            if len(parts) < max_parts:
                rec(deg_used + v, parts + [v])
    rec(0, [])
    return dict(res)

def main():
    t0 = time.time()
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    D = int(sys.argv[4])
    even = len(sys.argv) > 5 and sys.argv[5] == 'even'
    rlist = [int(x) for x in sys.argv[6:]] if len(sys.argv) > 6 else [4, 5, 6, 7]
    if not rlist:
        rlist = [4, 5, 6, 7]
    eps = en / ed
    gen = gen_multisets_even if even else gen_multisets
    basis = sorted(gen(D, D), key=lambda kk: (sum(kk), kk))
    n = len(basis)
    print(f"k={k} eps={en}/{ed} D={D} {'even' if even else 'all'} n={n} rlist={rlist}", flush=True)
    t1 = time.time()
    H_cache = {}
    for coords in (k, k - 1):
        for key in gen(2 * D, 2 * D):
            H_of_float(list(key), coords, H_cache)
    print(f"H cache built ({time.time()-t1:.0f}s, {len(H_cache)} entries)", flush=True)
    best, best_r = -1.0, None
    for r in rlist:
        t2 = time.time()
        I, J1 = build_matrices_float(k, eps, r, basis, H_cache)
        lam = float_lambda_max(I, J1)
        M = k * lam
        print(f"  r={r}: M ~= {M:.6f}  (build {time.time()-t2:.0f}s)", flush=True)
        if M > best:
            best, best_r = M, r
    print(f"RESULT k={k} eps={en}/{ed} D={D} {'even' if even else 'all'}: M ~= {best:.6f} at r={best_r}  (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
