#!/usr/bin/env python3
"""cs_opt7.py — 优化 φ(s)=1/g(s) (M 节点对数网格) 最小化 CS 无限维上界
内层 sup: 两值分布扫描 + 均匀 + 顶点; 约束: int_{s0}^{ks0} 1/phi <= k-1
外层: 差分进化 (优化: 内层粗 + 约束粗)
"""
import numpy as np
from scipy.optimize import differential_evolution
from scipy.interpolate import interp1d

def build_phi(vals, sgrid):
    return interp1d(sgrid, vals, kind='linear', bounds_error=False,
                    fill_value=(vals[0], vals[-1]))

def sup_simplex(phi, k, K, na=50):
    best = -1e9
    for m1 in range(1, k):
        m2 = k - m1
        a_max = K / m1
        for ai in np.linspace(1e-9, a_max, na):
            bv = (K - m1 * ai) / m2
            if bv < 1e-9: continue
            val = m1 * phi(ai) + m2 * phi(bv)
            if val > best: best = val
    best = max(best, k * phi(K / k))
    best = max(best, phi(K) + (k - 1) * phi(1e-9))
    return best

def constraint_ok(phi, k, S, n=50):
    for s0 in np.linspace(1e-8, S, n):
        sg = np.linspace(s0, k * s0, 30)
        v = np.trapz(1.0 / np.maximum(phi(sg), 1e-15), sg)
        if v > (k - 1) * 1.001:
            return False
    return True

def objective(vals, sgrid, k, K, S):
    phi = build_phi(vals, sgrid)
    if not constraint_ok(phi, k, S):
        return 1e6
    return sup_simplex(phi, k, K)

def run(k, eps, M=10, seed=0):
    S = 1 + eps; K = k * S
    sgrid = np.geomspace(1e-6, K, M)
    lin = np.log(k)/(k-1)
    x0 = lin * sgrid
    base = sup_simplex(build_phi(x0, sgrid), k, K)
    print(f'k={k} eps={eps}: 论文上界 {K*np.log(k)/(k-1):.6f}, 网格基线 {base:.6f}')
    bounds = [(1e-6, 20.0)] * M
    res = differential_evolution(lambda v: objective(v, sgrid, k, K, S),
                                 bounds, seed=seed, maxiter=40, popsize=20,
                                 tol=1e-8, polish=True, workers=1)
    print(f'  → 优化上界 {res.fun:.6f}  {"<4!!!" if res.fun < 4 else ""}')
    return res.fun

if __name__ == '__main__':
    import sys
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    run(k, en/ed)
