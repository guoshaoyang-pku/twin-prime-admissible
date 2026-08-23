#!/usr/bin/env python3
"""cs_opt6.py — 双层优化: 离散 φ(s)=1/g(s) (M 节点, 对数网格 [0,kS])
内层: sup over simplex (两值分布扫描 + 均匀 + 顶点) of sum φ(s_i)
约束: int_{s0}^{ks0} 1/φ <= k-1 对所有 s0 in [0,S] (积分检查)
外层: 差分进化优化 φ 节点值
"""
import numpy as np
from scipy.optimize import differential_evolution
from scipy.interpolate import interp1d

def build_phi(vals, sgrid):
    """vals: M 节点值 -> 插值函数 (线性, s 域)"""
    return interp1d(sgrid, vals, kind='linear', bounds_error=False,
                    fill_value=(vals[0], vals[-1]))

def sup_simplex(phi, k, K, na=120, extra=True):
    """sup over 两值分布 m1*a + m2*b = K"""
    best = -1e9
    for m1 in range(1, k):
        m2 = k - m1
        a_max = K / m1
        for ai in np.linspace(1e-9, a_max, na):
            bv = (K - m1 * ai) / m2
            if bv < 1e-9: continue
            val = m1 * phi(ai) + m2 * phi(bv)
            if val > best: best = val
    # 均匀 + 顶点
    if extra:
        best = max(best, k * phi(K / k))
        best = max(best, phi(K) + (k - 1) * phi(1e-9))
    return best

def constraint_ok(phi, k, S, n=120):
    for s0 in np.linspace(1e-8, S, n):
        sg = np.linspace(s0, k * s0, 80)
        v = np.trapz(1.0 / np.maximum(phi(sg), 1e-15), sg)
        if v > (k - 1) * 1.0001:
            return False
    return True

def objective(vals, sgrid, k, K, S):
    phi = build_phi(vals, sgrid)
    if not constraint_ok(phi, k, S):
        return 1e6
    return sup_simplex(phi, k, K)

k, eps = 49, 1/50
S = 1 + eps
K = k * S
M = 14
sgrid = np.geomspace(1e-6, K, M)
print(f'k={k} eps=1/50: 论文上界 {K*np.log(k)/(k-1):.6f}, 目标 < 4')

# 线性 φ = s*ln k/(k-1) 作为起点 (论文)
lin = np.log(k)/(k-1)
x0 = lin * sgrid
print(f'起点(论文)上界: {sup_simplex(build_phi(x0, sgrid), k, K):.6f}')

bounds = [(1e-6, 10.0)] * M
res = differential_evolution(lambda v: objective(v, sgrid, k, K, S),
                             bounds, seed=1, maxiter=80, popsize=25,
                             tol=1e-9, polish=True, workers=1)
print(f'优化后上界: {res.fun:.6f}  {"<4!!!" if res.fun < 4 else ""}')
print('节点值:', np.round(res.x, 4))
