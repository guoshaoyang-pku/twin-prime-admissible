#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dscan.py — float heuristic family max for several D values at fixed (k, eps, r).
Usage: python3 dscan.py k eps_num eps_den r D1 D2 ...
Prints for each D: float lambda_max and M = k*lambda_max, with stage timings.
"""
import sys, time
sys.path.insert(0, '.')
sys.path.insert(0, 'dsh_scan')
import floatbuild as fb


def gen_multisets(max_deg, max_parts, min_val=1):
    res = {}
    def rec(deg_used, parts):
        key = tuple(sorted(parts))
        res[key] = sum(parts)
        for v in range(min_val, max_deg - deg_used + 1):
            if len(parts) < max_parts:
                rec(deg_used + v, parts + [v])
    rec(0, [])
    return res


def main():
    t0 = time.time()
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    r = int(sys.argv[4]); Ds = [int(x) for x in sys.argv[5:]]
    eps_f = en / ed
    for D in Ds:
        t1 = time.time()
        basis_list = sorted(gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
        H_cache = {}
        for coords in (k, k - 1):
            for key in gen_multisets(2 * D, 2 * D):
                fb.H_of_float(list(key), coords, H_cache)
        t2 = time.time()
        I, J1 = fb.build_matrices_float(k, eps_f, r, basis_list, H_cache)
        t3 = time.time()
        lam = fb.float_lambda_max(I, J1)
        M = k * lam
        print(f"k={k} eps={en}/{ed} D={D} r={r} n={len(basis_list)}: "
              f"H={t2-t1:.0f}s build={t3-t2:.0f}s  lambda_max~={lam:.9f}  M~={M:.6f}", flush=True)
    print(f"TOTAL {time.time()-t0:.0f}s", flush=True)


if __name__ == "__main__":
    main()
