#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Verify fastbuild against original mk_probe_strict.build_matrices (exact equality)."""
import sys, time, importlib.util
sys.path.insert(0, '.')
import fastbuild
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
from fractions import Fraction as Fr

def run(k, en, ed, D, r):
    eps = Fr(en, ed)
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    H_cache = {}
    for coords in (k, k - 1):
        for key in s.gen_multisets(2 * D, 2 * D):
            s.H_of(list(key), coords, H_cache)
    t0 = time.time()
    I1, J1 = s.build_matrices(k, eps, r, basis, H_cache)
    t1 = time.time()
    fb = fastbuild.make_fast_build_matrices()
    t2 = time.time()
    I2, J2 = fb(k, eps, r, basis, H_cache)
    t3 = time.time()
    n = len(basis)
    ok = True
    for i in range(n):
        for j in range(n):
            if I1[i][j] != I2[i][j] or J1[i][j] != J2[i][j]:
                ok = False
                print(f"MISMATCH at ({i},{j}): I {I1[i][j]} vs {I2[i][j]}; J {J1[i][j]} vs {J2[i][j]}")
                break
        if not ok:
            break
    print(f"k={k} eps={eps} D={D} r={r} n={n}: identical={ok}  orig={t1-t0:.1f}s  fast={t3-t2:.1f}s  speedup={(t1-t0)/max(t3-t2,0.01):.1f}x")

run(10, 1, 4, 4, 3)
run(46, 1, 25, 8, 6)
