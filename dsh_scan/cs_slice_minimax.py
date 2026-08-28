#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_slice_minimax.py — 逐切片归一化 CS 上界: min_G max_t Σ_{有效} 1/G_i(t)
Lemma cs 对 M_{k,eps} 的精确形式（论文证明缺陷修复版）:
  M_{k,eps} <= ess sup_{t ∈ (1+eps)R_k} Σ_{i: t_{-i} ∈ (1-eps)R_{k-1}} 1/G_i(t)
  约束: 每切片 t_{-i}（s = 1-Σ_{j≠i}t_j >= eps）: ∫_0^{s+eps} G_i(t_i; t_{-i}) dt_i <= 1
  无效切片: G_i 无约束 ⟹ 1/G_i = 0
幂族: G_i(t_i) = c(s)·(s+(k-1)t_i)^{-p}, 逐切片归一化 ∫G_i = 1
  ⟹ 1/G_i(t) = (s+(k-1)t_i)^p · [(∫_0^{s+eps}(s+(k-1)x)^{-p}dx)^{-1}]
p=1: 论文形; p<1: 更平缓; p>1: 更尖
"""
import numpy as np
from scipy.optimize import minimize

def norm_inv(s, p, k, eps):
    """(∫_0^{s+eps} (s+(k-1)x)^{-p} dx)^{-1}"""
    L = s + eps  # 切片长度
    if abs(p - 1) < 1e-12:
        return (k-1) / np.log((k*s + (k-1)*eps) / s)
    a = s; b = k*s + (k-1)*eps
    return (k-1)*(1-p) / (b**(1-p) - a**(1-p))

def invG(s, x, p, k, eps):
    """1/G_i(t) 在切片 s、t_i = x 处"""
    return (s + (k-1)*x)**p * norm_inv(s, p, k, eps)

def sup_sym(m, a, b, p, k, eps):
    u = m*a + (k-m)*b
    if u > 1+eps + 1e-12:
        return None
    tot = 0.0
    for i in range(k):
        ti = a if i < m else b
        s_i = 1 - u + ti
        if s_i >= eps - 1e-12:
            tot += invG(s_i, ti, p, k, eps)
    return tot

def scan(k, eps, p, na=70):
    best = -1e9
    arg = None
    for m in range(1, k+1):
        for a in np.linspace(0, (1+eps)/m, na):
            for b in np.linspace(0, (1+eps)/max(1,k-m), na):
                v = sup_sym(m, a, b, p, k, eps)
                if v is not None and v > best:
                    best = v; arg = (m, a, b)
    # 局部精化
    if arg:
        m0, a0, b0 = arg
        def obj(x):
            v = sup_sym(m0, x[0], x[1], p, k, eps)
            return -v if v is not None else 1e9
        res = minimize(obj, [a0, b0], bounds=[(0,(1+eps)/m0),(0,(1+eps)/max(1,k-m0))],
                       method='Nelder-Mead', options={'xatol':1e-13,'fatol':1e-15,'maxiter':10000})
        v = -obj(res.x)
        if v > best: best, arg = v, (m0, res.x[0], res.x[1])
    return best, arg

if __name__ == '__main__':
    k, eps = 49, 1/25
    print(f'k={k} eps={eps} 逐切片幂族 minimax (sup over t):')
    for p in [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.5, 2.0]:
        v, arg = scan(k, eps, p)
        print(f'  p={p:.1f}: sup = {v:.6f}  {"<4!!!" if v < 4 else ""}  (m={arg[0]}, a={arg[1]:.5f}, b={arg[2]:.5f})')
