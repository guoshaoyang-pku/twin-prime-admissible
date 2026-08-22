#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_bisect.py — 严格区间验证: 精确有理数 LDL^T 惯性定理二分
λ_max(J1, I) > mid ⟺ J1 - mid·I 有正特征值 ⟺ ldl_sign 有正枢轴。
在 float64 结果 λ* 附近二分, 得到包含 λ* 的严格区间 [lo, hi]。
用法: python3 verify_bisect.py k D lam_float [halfwidth=1e-9]
"""
import sys, time, pickle
from fractions import Fraction as Fr
sys.path.insert(0, '..')
import importlib.util
spec = importlib.util.spec_from_file_location("mps", "../mk_probe_strict.py")
mps = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mps)
ldl_sign = mps.ldl_sign

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    lam = float(sys.argv[3])
    hw = float(sys.argv[4]) if len(sys.argv) > 4 else 1e-9
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    print(f"k={k} D={D} n={n}  target λ* = {lam:.15f}  halfwidth = {hw:.1e}", flush=True)

    def has_pos(mid):
        Am = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
        pv = ldl_sign(Am)
        if pv is None:
            return None
        return any(pv)

    # 从 λ* 出发逐步加宽
    for scale in (1.0, 10.0, 100.0):
        for sgn, tag in ((-1, 'lo'), (+1, 'hi')):
            mid = lam + sgn * hw * scale
            t0 = time.time()
            r = has_pos(mid)
            print(f"  mid = λ* {sgn} {hw*scale:.1e} = {mid:.15f}: has_pos = {r}  ({time.time()-t0:.0f}s)", flush=True)
            if r is True:
                print(f"  ⇒ λ_max > {mid:.15f}", flush=True)
            elif r is False:
                print(f"  ⇒ λ_max < {mid:.15f}", flush=True)
            else:
                print("  zero pivot — retry needed", flush=True)

if __name__ == '__main__':
    main()
