#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""min_core.py — 路线 B 核心积分 (单 min 截断, 精确有理数)
K[a,γ] = ∫_{R_k} (1-P1)^a · (ρ - M1)_+ · p_γ(u) du,
  M1 = max_i P1^{(i)} = P1 - min_i u_i,  ρ = (1-ε)/(1+ε)
推导 (见 piecewise_design.md):
  K[a,γ] = k · Σ_{J} Π_l C(γ_l, j_l) · H(J;k-1)/(k-2+d_J)! · T[a, B, C]
  B = deg(γ)-Σj_l, C = k-2+d_J,
  T[a,B,C] = ∫_0^{1-ρ} m^B ∫_0^{A} (L-W)^a (A-W) W^C dW dm,  A=ρ-(k-1)m, L=1-km
  内层 = Σ_{q=0}^a C(a,q)(-1)^q [ A^{C+1+q}/(C+1+q)·L^{a-q} - A^{C+2+q}/(C+2+q)·L^{a-q} ]
用法: 模块提供 K_exact(k, eps, a, gamma, H_cache, T_cache) → Fraction
"""
import math
from fractions import Fraction as Fr

def multiset_key(parts):
    return tuple(sorted(parts))

def H_exact(parts, coords, cache):
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    dp = {(): Fr(1)}
    for v in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx in range(len(state)):
                if idx > 0 and state[idx - 1] == state[idx]:
                    continue
                mult = state.count(state[idx])
                ns = list(state); ns[idx] += v; ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, Fr(0)) + cnt * mult
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, Fr(0)) + cnt
        dp = ndp
    val = Fr(0)
    for state, cnt in dp.items():
        if len(state) <= coords:
            f = math.factorial(coords) // math.factorial(coords - len(state))
            val += cnt * math.prod(math.factorial(s) for s in state) * f
    cache[key] = val
    return val

def T_exact(k, rho, a, B, C, cache):
    """T[a,B,C] = ∫ m^B · Inner(m) dm,  区域 R = {m≥0, W≥0, km+W≤1, (k-1)m+W≤ρ}
    Inner(m) = ∫_0^{Wmax}(L-W)^a(A-W)W^C dW,  L=1-km, A=ρ-(k-1)m, Wmax=min(L,A)
      m ≤ 1-ρ (A≤L): Σ_q C(a,q)(-1)^q L^{a-q} A^{C+2+q}/((C+1+q)(C+2+q))
      m > 1-ρ (A>L): a!C!/(a+C+1)! · L^{a+C+1}·[ (A-L) + L·(C+1)/(a+C+2) ]
    外层 m ∈ [0, m*], m* = min(1/k, ρ/(k-1)), 分段积分 (多项式闭式)。"""
    key = (k, rho.numerator, rho.denominator, a, B, C)
    if key in cache:
        return cache[key]
    one = Fr(1)
    km1 = k - 1
    mstar = min(Fr(1, k), rho / km1)
    rho1 = one - rho  # 1-ρ
    tot = Fr(0)
    if rho1 > 0:
        # 第一段: m ∈ [0, min(mstar, 1-ρ)]
        m1 = mstar if mstar < rho1 else rho1
        for q in range(a + 1):
            cq = Fr(math.comb(a, q)) * ((-1) ** q) / Fr((C + 1 + q) * (C + 2 + q))
            for r in range(a - q + 1):
                Lr = Fr(math.comb(a - q, r)) * ((-k) ** r)
                for p in range(C + 2 + q + 1):
                    Ap = Fr(math.comb(C + 2 + q, p)) * (rho ** (C + 2 + q - p)) * ((-km1) ** p)
                    pw = B + r + p
                    tot += cq * Lr * Ap * (m1 ** (pw + 1)) / Fr(pw + 1)
        # 第二段: m ∈ (1-ρ, mstar] (若 mstar > 1-ρ)
        if mstar > rho1:
            beta = Fr(math.factorial(a) * math.factorial(C), math.factorial(a + C + 1))
            # L^{a+C+1}·[(A-L) + L·(C+1)/(a+C+2)]
            # (A-L) = (ρ-(k-1)m) - (1-km) = ρ-1+m = m - (1-ρ) = m - rho1
            # 项1: L^{a+C+1}·(m-rho1);  项2: L^{a+C+2}·(C+1)/(a+C+2)
            def poly_int(c0, c1, E):
                # ∫_{rho1}^{mstar} m^B·L^E·(c0 + c1·m) dm, L = 1-km
                s = Fr(0)
                for r in range(E + 1):
                    Lr = Fr(math.comb(E, r)) * ((-k) ** r)
                    for (c, mpow) in ((c0, B + r), (c1, B + r + 1)):
                        s += Fr(c) * Lr * (mstar ** (mpow + 1) - rho1 ** (mpow + 1)) / Fr(mpow + 1)
                return s
            tot += beta * (poly_int(-rho1, 1, a + C + 1)
                           + Fr(a + 1, a + C + 2) * poly_int(1, 0, a + C + 2))
    cache[key] = tot
    return tot

def T2_exact(k, rho, a, B, C, cache):
    """T2[a,B,C] = ∫ m^B · Inner2(m) dm, 区域同 T_exact,
    Inner2(m) = ∫_0^{Wmax}(L-W)^a(A-W)^2 W^C dW
      m ≤ 1-ρ (A≤L): Σ_q C(a,q)(-1)^q L^{a-q} A^{C+3+q}·[1/(C+1+q)-2/(C+2+q)+1/(C+3+q)]
      m > 1-ρ (A>L): a!C!/(a+C+1)!·L^{a+C+1}·[(A-L)² + 2(A-L)L(a+1)/(a+C+2) + L²(a+2)(a+1)/((a+C+2)(a+C+3))]"""
    key = ('sq', k, rho.numerator, rho.denominator, a, B, C)
    if key in cache:
        return cache[key]
    one = Fr(1)
    km1 = k - 1
    mstar = min(Fr(1, k), rho / km1)
    rho1 = one - rho
    tot = Fr(0)
    if rho1 > 0:
        m1 = mstar if mstar < rho1 else rho1
        for q in range(a + 1):
            cq = Fr(math.comb(a, q)) * ((-1) ** q)
            cq *= (Fr(1, C + 1 + q) - Fr(2, C + 2 + q) + Fr(1, C + 3 + q))
            for r in range(a - q + 1):
                Lr = Fr(math.comb(a - q, r)) * ((-k) ** r)
                for p in range(C + 3 + q + 1):
                    Ap = Fr(math.comb(C + 3 + q, p)) * (rho ** (C + 3 + q - p)) * ((-km1) ** p)
                    pw = B + r + p
                    tot += cq * Lr * Ap * (m1 ** (pw + 1)) / Fr(pw + 1)
        if mstar > rho1:
            beta = Fr(math.factorial(a) * math.factorial(C), math.factorial(a + C + 1))
            # (A-L) = m - rho1
            def poly_int(c0, c1, c2, E):
                # ∫_{rho1}^{mstar} m^B L^E (c0 + c1 m + c2 m²) dm
                s = Fr(0)
                for r in range(E + 1):
                    Lr = Fr(math.comb(E, r)) * ((-k) ** r)
                    for (c, mpow) in ((c0, B + r), (c1, B + r + 1), (c2, B + r + 2)):
                        s += Fr(c) * Lr * (mstar ** (mpow + 1) - rho1 ** (mpow + 1)) / Fr(mpow + 1)
                return s
            # (A-L)² = (m-rho1)² = m² - 2 rho1 m + rho1²
            tot += beta * (poly_int(rho1 ** 2, -2 * rho1, 1, a + C + 1)
                           + Fr(2 * (a + 1), a + C + 2) * poly_int(-rho1, 1, 0, a + C + 2)
                           + Fr((a + 2) * (a + 1), (a + C + 2) * (a + C + 3)) * poly_int(1, 0, 0, a + C + 3))
    cache[key] = tot
    return tot

def K2q_exact(k, eps, a, gamma, H_cache, T_cache):
    """K2q[a,γ] = ∫_{R_k} (1-P₁)^a (ρ-M₁)_+² p_γ du (精确有理)"""
    rho = (1 - eps) / (1 + eps)
    deg = sum(gamma)
    tot = Fr(0)
    def rec(l, B, J, coef):
        nonlocal tot
        if l == len(gamma):
            dJ = sum(J)
            C = k - 2 + dJ
            if len(J) == 0:
                Hval = Fr(1)
            else:
                Hval = H_exact(J, k - 1, H_cache)
            tot += coef * Hval / Fr(math.factorial(k - 2 + dJ)) * T2_exact(k, rho, a, B, C, T_cache)
            return
        g = gamma[l]
        rec(l + 1, B + g, J, coef * k)
        for j in range(1, g + 1):
            rec(l + 1, B + (g - j), J + [j], coef * math.comb(g, j))
    rec(0, 0, [], Fr(1))
    return tot * k

def K_exact(k, eps, a, gamma, H_cache, T_cache):
    """K[a,γ] = ∫_{R_k} (1-P₁)^a (ρ-M₁)_+ p_γ du (精确有理, k 倍最小坐标对称性已含)"""
    rho = (1 - eps) / (1 + eps)
    deg = sum(gamma)
    tot = Fr(0)
    # 展开 p_γ = Π_l (k·m^{γ_l}·[j=0] + Σ_{j=1..γ_l} C(γ_l,j) m^{γ_l-j} p_j(w))
    def rec(l, B, J, coef):
        nonlocal tot
        if l == len(gamma):
            dJ = sum(J)
            C = k - 2 + dJ
            if len(J) == 0:
                Hval = Fr(1)
            else:
                Hval = H_exact(J, k - 1, H_cache)
            tot += coef * Hval / Fr(math.factorial(k - 2 + dJ)) * T_exact(k, rho, a, B, C, T_cache)
            return
        g = gamma[l]
        rec(l + 1, B + g, J, coef * k)  # j=0: k·m^g (u1 项 + 其余坐标 p0(w)=k-1)
        for j in range(1, g + 1):
            c = math.comb(g, j)
            rec(l + 1, B + (g - j), J + [j], coef * c)
    rec(0, 0, [], Fr(1))
    return tot * k

if __name__ == '__main__':
    # 快速自检: k=2 时与数值积分对比 (Simpson)
    import sys
    k = int(sys.argv[1]) if len(sys.argv) > 1 else 2
    eps = Fr(int(sys.argv[2]), int(sys.argv[3])) if len(sys.argv) > 3 else Fr(0)
    Hc, Tc = {}, {}
    for a in range(3):
        for gamma in [(), (2,), (4,), (2, 2)]:
            v = K_exact(k, eps, a, gamma, Hc, Tc)
            print(f"K[a={a}, γ={gamma}] = {v} ≈ {float(v):.12e}")
