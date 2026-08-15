#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
batch_k.py — strict scan grouped by k: build H cache ONCE, then for each
(eps_num, eps_den): build Gram pair, LDL^T verdict, rational bisection.
Usage: python3 batch_k.py k D r iters en1 ed1 en2 ed2 ...
"""
import sys, time, importlib.util
sys.path.insert(0, '.')
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
import fastbuild
fastbuild.patch(s)  # cached build_matrices (verified identical)
from fractions import Fraction as Fr

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    r = int(sys.argv[3]); iters = int(sys.argv[4])
    pairs = []
    rest = sys.argv[5:]
    for i in range(0, len(rest), 2):
        pairs.append((int(rest[i]), int(rest[i+1])))
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    n = len(basis)
    H_cache = {}
    for coords in (k, k - 1):
        for key in s.gen_multisets(2 * D, 2 * D):
            s.H_of(list(key), coords, H_cache)
    t1 = time.time()
    print(f"k={k} D={D} r={r} n={n} H_precomp={t1-t0:.0f}s eps={[f'{a}/{b}' for a,b in pairs]}", flush=True)
    for (en, ed) in pairs:
        eps = Fr(en, ed)
        t2 = time.time()
        I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
        t3 = time.time()
        A = [[J1[i][j] - Fr(4, k) * I[i][j] for j in range(n)] for i in range(n)]
        piv = s.ldl_sign(A)
        verdict = "ZERO-PIVOT" if piv is None else ("POS-EIG" if any(piv) else "ALL-NEG")
        lo, hi = Fr(0), Fr(4, k)
        for it in range(iters):
            mid = (lo + hi) / 2
            Am = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
            pv = s.ldl_sign(Am)
            if pv is None:
                lo = hi = mid
                break
            if any(pv):
                lo = mid
            else:
                hi = mid
        t4 = time.time()
        print(f"  eps={eps}: build={t3-t2:.0f}s bisect+verdict={t4-t3:.0f}s "
              f"verdict={verdict}  lambda_max in ({float(lo):.9f}, {float(hi):.9f})  "
              f"M in ({float(k*lo):.6f}, {float(k*hi):.6f})", flush=True)
    print(f"k={k} done total={time.time()-t0:.0f}s", flush=True)

if __name__ == "__main__":
    main()
