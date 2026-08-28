#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_improved.py — 改进 CS 上界: 逐切片精确归一化 G_i + 只对有效切片求和
论文 Lemma cs: M_{k,eps} <= ess sup_t Σ_{i: s_i>=eps} 1/G_i(t)
  s_i = 1 - Σ_{j≠i} t_j  (t_{-i} ∈ (1-eps)R_{k-1} ⟺ s_i >= eps)
逐切片最优(线性形状) G_i(t_i) = c(s_i)/(s_i+(k-1)t_i), 精确归一化:
  ∫_0^{s_i+eps} G_i dt_i = 1 ⟹ c(s) = (k-1)/ln((ks+(k-1)eps)/s)
  ⟹ 1/G_i(t) = (s_i+(k-1)t_i)·ln((ks_i+(k-1)eps)/s_i)/(k-1)
sup 在 t ∈ (1+eps)R_k, 对有效 i 求和。对称假设: m 个坐标取 a, k-m 取 b。
"""
import numpy as np
from scipy.optimize import minimize

def phi(s, x, k, eps):
    """1/G_i 在切片 s 处、t_i = x 的值"""
    L = np.log((k*s + (k-1)*eps) / s)
    return (s + (k-1)*x) * L / (k-1)

def sup_sym(m, a, b, k, eps):
    """对称 t: m 个坐标 = a, k-m 个 = b, ma+(k-m)b <= 1+eps"""
    u = m*a + (k-m)*b
    if u > 1+eps + 1e-12:
        return None
    tot = 0.0
    for i in range(k):
        ti = a if i < m else b
        s_i = 1 - u + ti
        if s_i >= eps - 1e-12:   # 有效切片
            tot += phi(s_i, ti, k, eps)
    return tot

def optimize(k, eps, nm=8, na=80):
    best = (-1e9, None)
    # sup over t: 最大化 Σ_{有效 i} 1/G_i(t)  (worst case; G 固定为逐切片归一化线性形)
    for m in range(1, k):
        for a in np.linspace(0, (1+eps)/m, na):
            for b in np.linspace(0, (1+eps)/(k-m), na):
                v = sup_sym(m, a, b, k, eps)
                if v is not None and v > best[0]:
                    best = (v, (m, a, b))
    # 局部精化 (最大化)
    m0, a0, b0 = best[1]
    def obj(x):
        a, b = x
        v = sup_sym(m0, a, b, k, eps)
        return -v if v is not None else 1e9
    res = minimize(obj, [a0, b0], bounds=[(0, (1+eps)/m0), (0, (1+eps)/(k-m0))],
                   method='Nelder-Mead', options={'xatol':1e-12, 'fatol':1e-14, 'maxiter':8000})
    v = -obj(res.x)
    if v > best[0]:
        best = (v, (m0, res.x[0], res.x[1]))
    return best

for eps in (1/50, 1/25, 1/147):
    k = 49
    v, arg = optimize(k, eps)
    print(f'k={k} eps={eps}: sup Σ1/G_i = {v:.8f}  (m={arg[0]}, a={arg[1]:.6f}, b={arg[2]:.6f})  {"<4!!!" if v < 4 else ""}')
