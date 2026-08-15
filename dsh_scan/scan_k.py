#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
scan_k.py — heuristic M_{k,eps} for one k and a list of epsilons, r-values.
Builds the H cache ONCE per k, then for each (eps, r) builds the Gram pair and
computes lambda_max via float numpy (fast heuristic) + prints M = k*lambda_max.
Usage: python3 scan_k.py k D r1 r2 [en1 ed1 en2 ed2 ...]
"""
import sys, time, importlib.util
sys.path.insert(0, '.')
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
import fastbuild
fastbuild.patch(s)  # cached build_matrices (verified identical)
from fractions import Fraction as Fr
import numpy as np

def float_lambda_max(I, J1):
    """Diagonal-preconditioned float estimate of lambda_max(J1, I).
    Scaling by D_i = I[i][i]^{-1/2} preserves the generalized spectrum and
    makes the scaled I well-conditioned (all diag = 1)."""
    n = len(I)
    Ifl = np.array([[float(I[i][j]) for j in range(n)] for i in range(n)])
    Jfl = np.array([[float(J1[i][j]) for j in range(n)] for i in range(n)])
    d = 1.0 / np.sqrt(np.maximum(np.diag(Ifl), 1e-300))
    Isc = Ifl * d[:, None] * d[None, :]
    Jsc = Jfl * d[:, None] * d[None, :]
    try:
        L = np.linalg.cholesky(Isc)
    except np.linalg.LinAlgError:
        Isc = Isc + 1e-13 * np.eye(n)
        L = np.linalg.cholesky(Isc)
    Linv = np.linalg.solve(L, np.eye(n))
    B = Linv @ Jsc @ Linv.T
    ev = np.linalg.eigvalsh(B)
    return float(ev[-1])

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    rvals = [int(x) for x in sys.argv[3].split(',')]
    pairs = []
    rest = sys.argv[4:]
    for i in range(0, len(rest), 2):
        pairs.append((int(rest[i]), int(rest[i+1])))
    t0 = time.time()
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    H_cache = {}
    for coords in (k, k - 1):
        for key in s.gen_multisets(2 * D, 2 * D):
            s.H_of(list(key), coords, H_cache)
    t1 = time.time()
    print(f"k={k} D={D} n={len(basis)} H_precomp={t1-t0:.0f}s r={rvals} eps={[f'{a}/{b}' for a,b in pairs]}", flush=True)
    for (en, ed) in pairs:
        eps = Fr(en, ed)
        for r in rvals:
            t2 = time.time()
            I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
            t3 = time.time()
            lam = float_lambda_max(I, J1)
            M = k * lam
            print(f"  eps={eps} r={r}: lambda_max={lam:.9f}  M={M:.6f}  (build={t3-t2:.0f}s)", flush=True)
    print(f"k={k} done, total={time.time()-t0:.0f}s", flush=True)

if __name__ == "__main__":
    main()
