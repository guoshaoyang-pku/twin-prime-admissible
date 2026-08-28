#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_posF.py — 正系数对称多项式 F 的构造性上界: min_c sup_t Σ_{有效}∫F dt_i/F(t)
F = Σ c_j (1+eps-P1)^{r_j} p_{γ_j}, c_j >= 0 ⟹ F >= 0 on (1+eps)R_k
Lemma cs (修复版): M_{k,eps} <= sup_t Σ_{i: t_{-i}∈(1-eps)R_{k-1}} ∫_0^{s_i+eps}F dt_i / F(t)
切片积分: 解析 (Beta) + 幂和展开。优化: scipy minimize over log c。
"""
import numpy as np
from math import factorial
from scipy.optimize import minimize

k, eps = 49, 1/25
ONE = 1 + eps

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def build_basis(D):
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    return basis

# ---------- 对称点 (m 个 a, k-m 个 b) 的求值 ----------
def F_eval(basis, c, m, a, b):
    u = m*a + (k-m)*b
    w = ONE - u
    if w <= 0: return 0.0
    tot = 0.0
    for j, (r, gamma) in enumerate(basis):
        p = 1.0
        for d in gamma:
            p *= (m*a**d + (k-m)*b**d)
        tot += c[j] * w**r * p
    return tot

def slice_int_sym(basis, c, m, a, b):
    """Σ_{有效切片 i} ∫_0^{s_i+eps} F dt_i
    a 组切片: u_rest = u-a, L = ONE-u_rest, 有效 ⟺ u_rest <= 1-eps
    ∫_0^L (L-x)^r Π_{d∈γ}(x^d + S_d) dx, S_d = (m-1)a^d + (k-m)b^d
    b 组切片: u_rest = u-b, S_d = m a^d + (k-m-1)b^d"""
    u = m*a + (k-m)*b
    tot = 0.0
    # a 组
    if m > 0:
        u_rest = u - a
        if u_rest <= 1-eps + 1e-12:
            L = ONE - u_rest
            for j, (r, gamma) in enumerate(basis):
                g = 0.0
                for mask in range(1 << len(gamma)):
                    xpow = 0; sprod = 1.0
                    for q, d in enumerate(gamma):
                        if mask >> q & 1: xpow += d
                        else: sprod *= ((m-1)*a**d + (k-m)*b**d)
                    g += sprod * L**(r+xpow+1) * factorial(r)*factorial(xpow)/factorial(r+xpow+1)
                tot += c[j] * g
    # b 组
    if k-m > 0:
        u_rest = u - b
        if u_rest <= 1-eps + 1e-12:
            L = ONE - u_rest
            for j, (r, gamma) in enumerate(basis):
                g = 0.0
                for mask in range(1 << len(gamma)):
                    xpow = 0; sprod = 1.0
                    for q, d in enumerate(gamma):
                        if mask >> q & 1: xpow += d
                        else: sprod *= (m*a**d + (k-m-1)*b**d)
                    g += sprod * L**(r+xpow+1) * factorial(r)*factorial(xpow)/factorial(r+xpow+1)
                tot += c[j] * g
    return tot

def sup_ratio(basis, logc, na=24):
    c = np.exp(logc)
    best = -1e9; arg = None
    for m in range(1, k+1):
        for a in np.linspace(1e-9, ONE/m, na):
            for b in np.linspace(0, ONE/max(1,k-m), na):
                u = m*a + (k-m)*b
                if u > ONE + 1e-12: continue
                F = F_eval(basis, c, m, a, b)
                if F <= 1e-15: continue
                num = slice_int_sym(basis, c, m, a, b)
                val = num/F
                if val > best: best, arg = val, (m, a, b)
    # u=0
    F0 = F_eval(basis, c, 1, 0, 0)
    if F0 > 1e-15:
        num0 = slice_int_sym(basis, c, 1, 0, 0)
        if num0/F0 > best: best, arg = num0/F0, (0,0,0)
    return best, arg

if __name__ == '__main__':
    D = 15
    basis = build_basis(D)
    n = len(basis)
    print(f'D={D} 基 n={n}', flush=True)
    # 初始: 全部 1
    c0 = np.ones(n)
    v, arg = sup_ratio(basis, np.log(c0), na=20)
    print(f'初始 c=1: sup={v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})', flush=True)
    # 优化 (Nelder-Mead 高维慢——用 Powell 或 COBYLA? 先试小步)
    def obj(logc):
        return sup_ratio(basis, logc, na=16)[0]
    # 逐步: 每次优化一个子集? 先试全量 Powell
    res = minimize(obj, np.log(c0), method='Powell',
                   options={'maxiter': 40, 'xtol': 1e-4, 'ftol': 1e-8})
    print(f'Powell 优化: sup={res.fun:.6f}', flush=True)
    v, arg = sup_ratio(basis, res.x, na=30)
    print(f'验证: sup={v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})  {"<4!!!" if v < 4 else ""}')
