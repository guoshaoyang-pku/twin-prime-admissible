#!/usr/bin/env python3
"""cs_final.py — k=49 彻底 CS 优化: DE 长跑 + 多参数化交叉验证"""
import numpy as np
from scipy.optimize import differential_evolution
from scipy.interpolate import interp1d

k, eps = 49, 1/50
S = 1 + eps; K = k * S
paper = K * np.log(k) / (k - 1)

def sup_simplex(phi, nodes, na=300):
    best = -1e9
    for a in nodes:
        for m in range(1, k):
            b = (K - m * a) / (k - m)
            if b < 0: continue
            val = m * phi(a) + (k - m) * phi(b)
            if val > best: best = val
    best = max(best, k * phi(K / k))
    best = max(best, phi(K) + (k - 1) * phi(1e-9))
    return best

def constraint_ok(phi, n=40):
    for s0 in np.linspace(1e-8, S, n):
        sg = np.linspace(s0, k * s0, 25)
        v = np.trapz(1.0 / np.maximum(phi(sg), 1e-15), sg)
        if v > (k - 1) * 1.001:
            return False
    return True

def obj_lin(vals, sgrid):
    phi = interp1d(sgrid, vals, kind='linear', bounds_error=False, fill_value=(vals[0], vals[-1]))
    if not constraint_ok(phi): return 1e6
    return sup_simplex(phi, sgrid)

print(f'k=49 eps=1/50: 论文上界 {paper:.6f}')
lin = np.log(k) / (k - 1)

# 参数化 1: 分段线性, 12 节点
for M in [12, 16]:
    sgrid = np.geomspace(1e-6, K, M)
    res = differential_evolution(lambda v: obj_lin(v, sgrid),
        [(lin*1e-6, lin*K*3)] * M, seed=11, maxiter=60, popsize=30,
        tol=1e-10, polish=True, workers=1)
    print(f'分段线性 M={M}: 优化上界 {res.fun:.6f} {"<4!!!" if res.fun < 4 else ""}')
