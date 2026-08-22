#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probe_lam.py — 并行精确惯性探测: 对一批 mid 值判定 λ_max > mid (精确有理 LDL^T)
用法: python3 probe_lam.py k D mid1 mid2 ... (mid 可为浮点)
"""
import sys, time, pickle
from fractions import Fraction as Fr
import multiprocessing as mp
sys.path.insert(0, '..')
import importlib.util
spec = importlib.util.spec_from_file_location("mps", "../mk_probe_strict.py")
mps = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mps)
ldl_sign = mps.ldl_sign

def worker(args):
    k, D, mid, I, J1 = args
    n = len(I)
    Am = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
    pv = ldl_sign(Am)
    if pv is None:
        return (mid, 'zero_pivot')
    return (mid, any(pv))

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    mids = [float(x) for x in sys.argv[3:]]
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    print(f"k={k} D={D} n={n}  probing {len(mids)} mid values", flush=True)
    tasks = [(k, D, m, I, J1) for m in mids]
    t0 = time.time()
    with mp.Pool(mp.cpu_count()) as pool:
        results = pool.map(worker, tasks)
    print(f"done in {time.time()-t0:.0f}s", flush=True)
    for mid, r in sorted(results):
        if r == 'zero_pivot':
            print(f"  mid = {mid:.15f}: zero pivot", flush=True)
        else:
            print(f"  mid = {mid:.15f}: λ_max {'>' if r else '<'} mid", flush=True)

if __name__ == '__main__':
    main()
