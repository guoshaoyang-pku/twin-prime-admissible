#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dcheck.py — Decimal(50)-digit power-iteration check of lambda_max(J1, I),
using EXACT Fraction->Decimal conversion (no float in between).
Usage: python3 dcheck.py k eps_num eps_den D r [iters] [prec]
"""
import sys, time, importlib.util
sys.path.insert(0, '.')
sys.path.insert(0, 'dsh_scan')
from fractions import Fraction as Fr
from decimal import Decimal, getcontext
import fastbuild

spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
fastbuild.patch(s)


def to_dec(F):
    return Decimal(F.numerator) / Decimal(F.denominator)


def solve(A, b, n):
    M = [row[:] + [bi] for row, bi in zip(A, b)]
    for c in range(n):
        p = max(range(c, n), key=lambda rr: abs(M[rr][c]))
        if p != c:
            M[c], M[p] = M[p], M[c]
        piv = M[c][c]
        if piv == 0:
            return None
        for j in range(c, n + 1):
            M[c][j] /= piv
        for rr in range(n):
            if rr != c and M[rr][c] != 0:
                f = M[rr][c]
                for j in range(c, n + 1):
                    M[rr][j] -= f * M[c][j]
    return [M[i][n] for i in range(n)]


def max_geig(I, J, iters, prec):
    getcontext().prec = prec
    n = len(I)
    Ifl = [[to_dec(I[i][j]) for j in range(n)] for i in range(n)]
    Jfl = [[to_dec(J[i][j]) for j in range(n)] for i in range(n)]
    D = [Decimal(1) / Ifl[i][i].sqrt() for i in range(n)]
    for i in range(n):
        for j in range(n):
            Ifl[i][j] *= D[i] * D[j]
            Jfl[i][j] *= D[i] * D[j]
    x = [Decimal(1) / Decimal(n).sqrt()] * n
    lam = Decimal(0)
    for it in range(iters):
        bx = [sum(Jfl[i][j] * x[j] for j in range(n)) for i in range(n)]
        y = solve(Ifl, bx, n)
        if y is None:
            return None, None
        nrm = sum(v * v for v in y).sqrt()
        if nrm == 0:
            break
        y = [v / nrm for v in y]
        num = sum(y[i] * sum(Jfl[i][j] * y[j] for j in range(n)) for i in range(n))
        den = sum(y[i] * sum(Ifl[i][j] * y[j] for j in range(n)) for i in range(n))
        new_lam = num / den
        if abs(new_lam - lam) < Decimal(10) ** (-prec + 6):
            lam = new_lam
            break
        lam = new_lam
        x = y
    return lam, x


def main():
    t0 = time.time()
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    D = int(sys.argv[4]); r = int(sys.argv[5])
    iters = int(sys.argv[6]) if len(sys.argv) > 6 else 80
    prec = int(sys.argv[7]) if len(sys.argv) > 7 else 50
    eps = Fr(en, ed)
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    H_cache = {}
    for coords in (k, k - 1):
        for key in s.gen_multisets(2 * D, 2 * D):
            s.H_of(list(key), coords, H_cache)
    t1 = time.time()
    I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
    t2 = time.time()
    lam, x = max_geig(I, J1, iters, prec)
    t3 = time.time()
    if lam is None:
        print(f"k={k} eps={en}/{ed} D={D} r={r}: SOLVER FAILED", flush=True)
        return
    print(f"k={k} eps={en}/{ed} D={D} r={r} n={len(basis)}: H={t1-t0:.0f}s build={t2-t1:.0f}s geig={t3-t2:.0f}s "
          f"lambda_max={float(lam):.10f}  M={float(k*lam):.6f}", flush=True)


if __name__ == "__main__":
    main()
