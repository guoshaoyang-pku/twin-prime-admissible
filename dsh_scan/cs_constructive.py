#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_constructive.py — 构造性无限维上界: 找正对称多项式 F 使 sup_t Σ_{有效}∫F dt_i/F(t) < 4
Lemma cs (修复版, 论文 Mkeps 证明缺陷修正): M_{k,eps} <= ess sup_{t∈(1+eps)R_k} Σ_{i: t_{-i}∈(1-eps)R_{k-1}} ∫F dt_i / F(t)
约束: F > 0 on (1+eps)R_k。取 F = Σ c_j (1+eps-P1)^{r_j} p_{γ_j} (c_j >= 0 ⟹ F >= 0)
切片积分解析: ∫_0^L (L-t)^r t^e dt = L^{r+e+1} r!e!/(r+e+1)!, L = s+eps
对对称 t (m 个 a, k-m 个 b): p_γ = Σ_{distinct monomials}
"""
import numpy as np
from fractions import Fraction
from math import factorial, comb

k, eps = 49, 1/25

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

def p_gamma_sym(gamma, m, a, b):
    """p_γ 在对称点 (m 个 a, k-m 个 b) 的值: Σ_{distinct monomials} t^e
    p_γ = Σ_{e 多重集 γ 的排列} t_1^{e_1}...t_k^{e_k}"""
    # 用生成函数: p_γ = 完全对称多项式 h_γ? 不——p_γ 是"幂和积"P_γ = Π_i (Σ_j t_j^{γ_i})
    # 论文的 p_γ 定义: P_γ(t) = Π_i p_{γ_i}(t), p_d = Σ_j t_j^d
    # 所以 p_γ = Π_{d∈γ} (m*a^d + (k-m)*b^d)
    val = 1.0
    for d in gamma:
        val *= (m * a**d + (k-m) * b**d)
    return val

def basis_eval(basis, c, m, a, b):
    """F = Σ c_j (1+eps-P1)^r p_γ 在对称点的值"""
    u = m*a + (k-m)*b
    w = 1 + eps - u   # 1+eps-P1
    F = 0.0
    for j, (r, gamma) in enumerate(basis):
        F += c[j] * w**r * p_gamma_sym(gamma, m, a, b)
    return F

def slice_int(basis, c, m, a, b):
    """Σ_i ∫_0^{s_i+eps} F dt_i (有效切片 i 的和) — 对称点
    对 i 在 a 组: 切片 t_{-i}: (m-1) 个 a, (k-m) 个 b, t_i = x ∈ [0, L_a]
      ∫_0^{L_a} F(t) dx 中 F = Σ c_j (L_a - x)^{r_j}?? 不对——(1+eps-P1) = 1+eps-(x+u_rest)
      对切片 i: u_rest = Σ_{j≠i} t_j = u - t_i。P1 = x + u_rest。1+eps-P1 = 1+eps-u_rest-x
      令 L = 1+eps-u_rest = s_i+eps (s_i = 1-u_rest)。∫_0^L (L-x)^{r} p_γ(t_i=x, t_{-i}固定) dx
      p_γ 含 t_i 的幂: 用 monomial 展开太繁 —— 用"切片幂和"技巧:
      ∫_0^L (L-x)^r x^d dx = L^{r+d+1} r!d!/(r+d+1)! 对单项式 x^d
      p_γ 在切片上 = Π_{d∈γ} (x^d + Σ_{j≠i} t_j^d) —— 展开为 x 的多项式
      对对称点: Σ_{j≠i} t_j^d = (m-1)a^d + (k-m)b^d (a 组) 或 m a^d + (k-m-1)b^d (b 组)
    """
    u = m*a + (k-m)*b
    tot = 0.0
    # a 组切片
    if m > 0:
        rest_d = (m-1)*a**0 + (k-m)*b**0  # = k-1
        L = 1 + eps - ((m-1)*a + (k-m)*b)
        if L > 0:
            for j, (r, gamma) in enumerate(basis):
                # ∫_0^L (L-x)^r Π_{d∈γ}(x^d + S_d) dx, S_d = (m-1)a^d+(k-m)b^d
                # 展开 Π(x^d+S_d) = Σ_{T⊆γ} x^{Σ_{d∈T}d} Π_{d∉T}S_d
                n_g = len(gamma)
                gsum = 0.0
                for mask in range(1 << n_g):
                    xpow = 0; sprod = 1.0
                    for q, d in enumerate(gamma):
                        if mask >> q & 1:
                            xpow += d
                        else:
                            sprod *= ((m-1)*a**d + (k-m)*b**d)
                    # ∫_0^L (L-x)^r x^{xpow} dx = L^{r+xpow+1}·r!·xpow!/(r+xpow+1)!
                    gsum += sprod * L**(r+xpow+1) * factorial(r)*factorial(xpow)/factorial(r+xpow+1)
                tot += c[j] * gsum
    # b 组切片
    if k-m > 0:
        L = 1 + eps - (m*a + (k-m-1)*b)
        if L > 0:
            for j, (r, gamma) in enumerate(basis):
                n_g = len(gamma)
                gsum = 0.0
                for mask in range(1 << n_g):
                    xpow = 0; sprod = 1.0
                    for q, d in enumerate(gamma):
                        if mask >> q & 1:
                            xpow += d
                        else:
                            sprod *= (m*a**d + (k-m-1)*b**d)
                    gsum += sprod * L**(r+xpow+1) * factorial(r)*factorial(xpow)/factorial(r+xpow+1)
                tot += c[j] * gsum
    return tot

def sup_ratio(c, basis, na=40):
    """sup_t Σ_{有效}∫F dt_i/F(t) — 对称网格扫描"""
    best = -1e9; arg = None
    for m in range(1, k+1):
        for a in np.linspace(1e-9, (1+eps)/m, na):
            for b in np.linspace(0, (1+eps)/max(1,k-m), na):
                u = m*a + (k-m)*b
                if u > 1+eps + 1e-12: continue
                s_a = 1-u+a; s_b = 1-u+b
                F = basis_eval(basis, c, m, a, b)
                if F <= 1e-12: continue
                num = slice_int(basis, c, m, a, b)
                # 只数有效切片: slice_int 已只对 L>0 加——L>0 ⟺ s_i+eps>0 ⟺ s_i > -eps
                # 但有效需 s_i >= eps。修正: 切片 i 有效 ⟺ t_{-i}∈(1-eps)R_{k-1} ⟺ Σ_{j≠i}t_j <= 1-eps
                # 对 a 组: Σ_{j≠i} = (m-1)a+(k-m)b <= 1-eps?
                num_a = 0.0
                if m > 0 and (m-1)*a + (k-m)*b <= 1-eps + 1e-12:
                    # 重算 a 组切片积分
                    L = 1 + eps - ((m-1)*a + (k-m)*b)
                    for j, (r, gamma) in enumerate(basis):
                        n_g = len(gamma); gsum = 0.0
                        for mask in range(1 << n_g):
                            xpow = 0; sprod = 1.0
                            for q, d in enumerate(gamma):
                                if mask >> q & 1: xpow += d
                                else: sprod *= ((m-1)*a**d + (k-m)*b**d)
                            gsum += sprod * L**(r+xpow+1) * factorial(r)*factorial(xpow)/factorial(r+xpow+1)
                        num_a += c[j]*gsum
                num_b = 0.0
                if k-m > 0 and m*a + (k-m-1)*b <= 1-eps + 1e-12:
                    L = 1 + eps - (m*a + (k-m-1)*b)
                    for j, (r, gamma) in enumerate(basis):
                        n_g = len(gamma); gsum = 0.0
                        for mask in range(1 << n_g):
                            xpow = 0; sprod = 1.0
                            for q, d in enumerate(gamma):
                                if mask >> q & 1: xpow += d
                                else: sprod *= (m*a**d + (k-m-1)*b**d)
                            gsum += sprod * L**(r+xpow+1) * factorial(r)*factorial(xpow)/factorial(r+xpow+1)
                        num_b += c[j]*gsum
                val = (num_a + num_b)/F
                if val > best: best, arg = val, (m, a, b)
    return best, arg

if __name__ == '__main__':
    D = 19
    basis = build_basis(D)
    n = len(basis)
    print(f'D={D} 基大小 n={n}')
    # F = Σ b_j (c_j=1): 正系数
    c = np.ones(n)
    v, arg = sup_ratio(c, basis, na=30)
    print(f'F=Σb_j: sup = {v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})  {"<4!!!" if v < 4 else ""}')
    # F = (1+eps-P1)^r 单元素
    for r in [1, 2, 3, 5, 8]:
        c = np.zeros(n)
        for j, (rj, g) in enumerate(basis):
            if rj == r and sum(g) == 0:
                c[j] = 1.0
        v, arg = sup_ratio(c, basis, na=30)
        print(f'F=(1+eps-P1)^{r}: sup = {v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})')
