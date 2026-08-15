#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Profile D=8 pipeline stage timings: H precomp, build, one LDL^T, one bisect iter.
Usage: python3 prof.py k eps_num eps_den D [r] > out  (run in background)"""
import sys, time, importlib.util
sys.path.insert(0, '.')
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
from fractions import Fraction as Fr

k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
D = int(sys.argv[4]); r = int(sys.argv[5]) if len(sys.argv) > 5 else 6
eps = Fr(en, ed)
t0 = time.time()
basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
t1 = time.time()
print(f"gen_multisets: {t1-t0:.1f}s  n={len(basis)}", flush=True)
H_cache = {}
for coords in (k, k - 1):
    for key in s.gen_multisets(2 * D, 2 * D):
        s.H_of(list(key), coords, H_cache)
t2 = time.time()
print(f"H precomp: {t2-t1:.1f}s", flush=True)
I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
t3 = time.time()
print(f"build_matrices: {t3-t2:.1f}s", flush=True)
n = len(basis)
A = [[J1[i][j] - Fr(4, k) * I[i][j] for j in range(n)] for i in range(n)]
piv = s.ldl_sign(A)
t4 = time.time()
print(f"1st LDL^T: {t4-t3:.1f}s  pivots={piv if piv is None else ('any_pos=' + str(any(piv))) if False else ('NEG' if (piv and not any(piv)) else ('POS' if piv and any(piv) else '?'))}", flush=True)
# one bisection step from mid=4/k/2
mid = Fr(4, k) / 2
Am = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
piv2 = s.ldl_sign(Am)
t5 = time.time()
print(f"2nd LDL^T (bisect step): {t5-t4:.1f}s", flush=True)
print(f"TOTAL: {t5-t0:.1f}s", flush=True)
