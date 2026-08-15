#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mk_driver.py — one-shot strict scan driver (build matrices ONCE, then):
   1) float generalized-eigen estimate of lambda_max (numpy, heuristic)
   2) exact LDL^T verdict on J1 - (4/k)*I   -> family-restricted M < 4 ? (strict)
   3) rational bisection of lambda_max     -> strict interval (iters LDL^T's)

This is a NEW helper that reuses mk_probe_strict.py (read-only) as a module.
Usage: python3 mk_driver.py k eps_num eps_den D [r] [iters] [outfile]
"""
import sys, math, time, importlib.util
sys.path.insert(0, '.')
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
from fractions import Fraction as Fr
import numpy as np


def float_lambda_max(I, J1):
    """numpy estimate of lambda_max(J1, I): B = L^{-1} J L^{-T}, L = chol(I)."""
    n = len(I)
    Ifl = np.array([[float(I[i][j]) for j in range(n)] for i in range(n)])
    Jfl = np.array([[float(J1[i][j]) for j in range(n)] for i in range(n)])
    try:
        L = np.linalg.cholesky(Ifl)
    except np.linalg.LinAlgError:
        # add tiny diagonal shift
        Ifl2 = Ifl + 1e-14 * np.eye(n)
        L = np.linalg.cholesky(Ifl2)
    Linv = np.linalg.solve(L, np.eye(n))
    B = Linv @ Jfl @ Linv.T
    ev = np.linalg.eigvalsh(B)
    return float(ev[-1]), float(ev[-2]) if n > 1 else float(ev[-1])


def main():
    t0 = time.time()
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    D = int(sys.argv[4])
    r = int(sys.argv[5]) if len(sys.argv) > 5 else 6
    iters = int(sys.argv[6]) if len(sys.argv) > 6 else 18
    out = sys.argv[7] if len(sys.argv) > 7 else None
    eps = Fr(en, ed)
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    n = len(basis)
    H_cache = {}
    for coords in (k, k - 1):
        for key in s.gen_multisets(2 * D, 2 * D):
            s.H_of(list(key), coords, H_cache)
    t1 = time.time()
    I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
    t2 = time.time()

    lam1, lam2 = float_lambda_max(I, J1)
    M1 = k * lam1

    # exact verdict on J1 - (4/k) I
    A = [[J1[i][j] - Fr(4, k) * I[i][j] for j in range(n)] for i in range(n)]
    piv = s.ldl_sign(A)
    if piv is None:
        verdict = "ZERO-PIVOT(4/k is an eigenvalue)"
    else:
        verdict = "POS-EIG (family max > 4/k)" if any(piv) else "ALL-NEG (family max < 4/k)"

    # rational bisection
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
    t3 = time.time()
    line1 = (f"k={k} eps={eps} D={D} r={r} n={n} "
             f"build={t1-t0:.0f}s mat={t2-t1:.0f}s total={t3-t0:.0f}s")
    line2 = (f"float: lambda_max={lam1:.12f} (2nd={lam2:.4f})  M~={M1:.6f}")
    line3 = f"LDL^T verdict: {verdict}"
    line4 = (f"strict: lambda_max in ({float(lo):.12f}, {float(hi):.12f})  "
             f"M in ({float(k*lo):.6f}, {float(k*hi):.6f})")
    print(line1)
    print(line2)
    print(line3)
    print(line4)
    if out:
        with open(out, "w") as f:
            f.write("\n".join([line1, line2, line3, line4]) + "\n")


if __name__ == "__main__":
    main()
