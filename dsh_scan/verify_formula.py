#!/usr/bin/env python3
"""独立数值积分验证 I, J1 闭式公式 (k=2,3 高精度 Simpson)"""
import math, sys
sys.path.insert(0, '.')
import floatbuild as fb

def simpson1d(f, a, b, N=2000):
    if b <= a: return 0.0
    h = (b - a) / N
    s = f(a) + f(b)
    for i in range(1, N):
        s += (4.0 if i % 2 else 2.0) * f(a + i * h)
    return s * h / 3.0

def I_num(k, F):
    # ∫_{R_k} F(t)² dt_1..dt_k — 递归 Simpson
    import functools
    def rec(dim, fixed):
        if dim == 1:
            L = 1.0 - sum(fixed)
            def f(x):
                t = list(fixed) + [x]
                return F(t) ** 2
            return simpson1d(f, 0.0, L)
        def outer(x):
            return rec(dim - 1, fixed + [x])
        L = 1.0 - sum(fixed)
        return simpson1d(outer, 0.0, L)
    return rec(k, [])

def J1_num(k, F):
    # ∫_{R_{k-1}} (∫_0^L F(t_1, t2..) dt_1)² dt_2.. — 递归
    def rec(dim, fixed):  # fixed = t_2..t_{k-dim+1}
        if dim == 1:
            L = 1.0 - sum(fixed)
            def inner(x1):
                t = [x1] + list(fixed)
                return F(t)
            g = simpson1d(inner, 0.0, L)
            return g ** 2 * L  # ∫_0^L g² dt 的"常数"？不对
        # dim ≥ 2: 对 t_{k-dim+2} 积分
        def outer(x):
            return rec(dim - 1, fixed + [x])
        L = 1.0 - sum(fixed)
        return simpson1d(outer, 0.0, L)
    return rec(k - 1, [])

# F = (1+eps-P1)^r p_gamma
def make_F(k, eps, r, gamma):
    def F(t):
        s = 1.0 + eps - sum(t)
        p = 1.0
        for v in gamma:
            p *= sum(x ** v for x in t)
        return (s ** r) * p if s > 0 else 0.0
    return F

for (k, eps, r, gamma) in [(2, 0.0, 1, (2,)), (2, 0.0, 0, (2,)), (3, 0.0, 1, (2,))]:
    F = make_F(k, eps, r, gamma)
    In = I_num(k, F)
    Jn = J1_num(k, F)
    # 闭式: I = (1+eps)^{k+2deg+2r} (2r)! H(2γ;k) / (k+2r+2deg)!
    g2 = tuple(sorted(gamma + gamma))
    Hc = {}
    In_closed = (1.0+eps)**(k + 2*sum(gamma) + 2*r) * math.factorial(2*r) * fb.H_of_float(list(g2), k, Hc) / math.factorial(k + 2*r + 2*sum(gamma))
    # J1 闭式 (用 floatbuild 的 build_matrices_float 单元素)
    basis = [gamma]
    H2 = {}
    for coords in (k, k-1):
        fb.H_of_float(list(g2), coords, H2)
        fb.H_of_float(list(gamma), coords, H2)
    I, J1 = fb.build_matrices_float(k, eps, r, basis, H2)
    print(f"k={k} eps={eps} r={r} gamma={gamma}")
    print(f"  I: numeric={In:.8f} closed={In_closed:.8f} (matrix[0][0]={I[0][0]:.8f})")
    print(f"  J1: numeric={Jn:.8f} matrix[0][0]={J1[0][0]:.8f}")
