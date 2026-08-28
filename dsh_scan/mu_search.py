#!/usr/bin/env python3
"""mu_search.py — 找对抗测度 mu: max_mu min_g E_mu[1/g]
若 max_min = S*ln k/(k-1) => CS 下界定理证明路线 (sup >= k*E_mu[1/g] >= k*min)
mu = 两值分布 (m 个 a, k-m 个 b=(kS-ma)/(k-m)); 外层扫描 (m,a)
"""
import numpy as np
from scipy.optimize import minimize

k, S = 49, 1.02
K = k * S
paper = S * np.log(k) / (k - 1)
print(f'目标值 (S ln k/(k-1)) = {paper:.8f}')

def min_g_for_mu(svals, wts, k, K):
    """min sum wts_i/g_i 受 int_{s0}^{ks0} g <= k-1 (离散)"""
    # 直接在 s 点上的 g 值 — 约束: 对 s0 网格检查积分
    # 简化: g_i 在 svals 处; 积分用梯形
    n = len(svals)
    # 排序
    order = np.argsort(svals)
    sv = svals[order]; w = wts[order]
    def obj(ginv):
        return np.sum(w * ginv)
    # 约束: 对每个 s0 in [0,S], sum over s in [s0, ks0] of g * ds <= k-1
    cons = []
    # 用线性插值近似积分 — 简化: 点值 g_i 视为"代表区间" — 用 delta 近似
    # 严格化: g 在节点间线性 — 积分可算 — 简化用梯形
    for s0 in np.linspace(1e-8, S, 30):
        idx = np.where((sv >= s0) & (sv <= k*s0))[0]
        if len(idx) == 0: continue
        # 梯形权重 (假设线性插值): 用每点的"影响宽度"
        dw = np.gradient(sv)
        ww = np.zeros(n)
        ww[idx] = dw[idx]
        cons.append({'type': 'ineq', 'fun': lambda ginv, ww=ww: (k-1) - np.sum(ww / np.maximum(ginv, 1e-15))})
    x0 = np.full(n, paper)
    res = minimize(obj, x0, method='SLSQP', constraints=cons, options={'maxiter': 150, 'ftol': 1e-12})
    return res.fun

# 两值分布扫描
best = (0, None)
for m in range(1, k):
    for ai in np.linspace(1e-6, K/m, 40):
        b = (K - m*ai) / (k - m)
        if b < 0: continue
        svals = np.array([ai, b])
        wts = np.array([m, k-m])
        val = min_g_for_mu(svals, wts, k, K)
        if val > best[0]:
            best = (val, (m, ai, b))
print(f'两值扫描: max min_g E_mu[1/g] = {best[0]:.8f}  (m={best[1][0]}, a={best[1][1]:.4f}, b={best[1][2]:.4f})')
print(f'论文值: {paper:.8f}  差距: {best[0]-paper:.6f}')
