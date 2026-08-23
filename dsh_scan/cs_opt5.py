#!/usr/bin/env python3
"""cs_opt5.py — 凹 φ(s) = 1/g(s): sup over simplex 在均匀点 (Jensen)
上界 = k*φ(S) (若 φ 凹且均匀最大); 约束 int_{s0}^{ks0} 1/φ(s) ds <= k-1
验证: 对凹 φ, sup 是否真在均匀; 数值 sup over 两值分布扫描
"""
import numpy as np
from scipy.optimize import minimize
from scipy.integrate import quad

def phi_quad(s, a, b, c):
    return a*s + b - c*s*s

def sup_two_val(phi, k, S, na=200):
    """sup over 两值分布: m1 个 a, m2 个 b, m1*a+m2*b = kS"""
    K = k*S
    best = -1e9
    for m1 in range(0, k+1):
        m2 = k - m1
        if m2 == 0: continue
        # a in [0, K/m1] (b >= 0), b = (K - m1*a)/m2
        for ai in np.linspace(1e-6, K/m1 if m1>0 else 0, na):
            bv = (K - m1*ai)/m2
            if bv < 0: continue
            val = m1*phi(ai) + m2*phi(bv)
            if val > best: best = val
    return best

def constraint_ok(a, b, c, k, S, n=300):
    """int_{s0}^{ks0} 1/phi <= k-1 对所有 s0 in [0,S]"""
    for s0 in np.linspace(1e-8, S, n):
        phi = phi_quad
        integrand = lambda s: 1/max(phi(s, a, b, c), 1e-12)
        v = quad(integrand, s0, k*s0, limit=50)[0]
        if v > (k-1) + 1e-8:
            return False
    return True

k, eps = 49, 1/50
S = 1 + eps
print(f'k={k} eps=1/50: 论文上界 {k*S*np.log(k)/(k-1):.6f}')
# 测试凹二次族
best = (1e9, None)
for a in [0.01, 0.05, 0.1, 0.3, 1.0]:
    for b in [0.01, 0.05, 0.1, 0.3, 1.0]:
        for c in [0.0, 0.01, 0.05, 0.1]:
            if c > 0 and a*a < 4*b*c: continue  # 需要 phi>0 在 [0,kS]
            if not constraint_ok(a, b, c, k, S):
                continue
            ub = sup_two_val(lambda s: phi_quad(s, a, b, c), k, S)
            if ub < best[0]:
                best = (ub, (a, b, c))
print(f'凹二次最优: 上界 {best[0]:.6f} (a={best[1][0]}, b={best[1][1]}, c={best[1][2]})')
# 对照: 线性 (c=0) 应该 = 论文
for (a,b) in [(np.log(k)/(k-1), 0.0)]:
    ub = sup_two_val(lambda s: a*s+b, k, S)
    print(f'线性对照 (a=ln k/(k-1)): 上界 {ub:.6f} (论文 {k*S*a:.6f})')
