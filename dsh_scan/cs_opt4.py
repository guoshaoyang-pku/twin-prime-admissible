#!/usr/bin/env python3
"""cs_opt4.py — g(s)=(as+b)^p, 修复 a->0 约束
约束(一般 s0): ((aks0+b)^{p+1}-(as0+b)^{p+1})/(a(p+1)) <= k-1
a->0: (k-1)s0 b^p <= k-1 (即 s0 b^p <= 1)  — s0=S 最坏
"""
import numpy as np
from scipy.optimize import minimize

def constraint(p, x, y, k, S, s0):
    """归一化 x=a*S, y=b: 约束值 (左-右) 应 <= 0; s0 尺度化"""
    a = x / S
    b = y
    t = s0 / S
    if a < 1e-12:
        return (k - 1) * s0 * b**p - (k - 1)   # a->0 极限
    lhs = ((k * a * s0 + b)**(p+1) - (a * s0 + b)**(p+1)) / (a * (p + 1))
    return lhs - (k - 1)

def feasible(p, x, y, k, S):
    for s0 in [S, S*0.5, S*0.1, 1e-6]:  # 关键点 (约束凸性: 只需检查端点? 保守多查)
        if constraint(p, x, y, k, S, s0) > 1e-9:
            return False
    return True

def upper(p, x, y, k):
    return (k*x + y)**(-p) + (k - 1) * y**(-p)

def opt_family(p, k, S):
    best = (1e9, None)
    for x0 in np.logspace(-4, 3, 30):
        for y0 in np.logspace(-4, 3, 30):
            if not feasible(p, x0, y0, k, S):
                continue
            def obj(v):
                x, y = v
                if x <= 0 or y <= 0: return 1e9
                if not feasible(p, x, y, k, S): return 1e9
                return upper(p, x, y, k)
            res = minimize(obj, [x0, y0], method='Nelder-Mead',
                          options={'maxiter': 400, 'xatol': 1e-12, 'fatol': 1e-14})
            if res.fun < best[0] and res.fun < 1e6:
                best = (res.fun, res.x)
    return best

k, eps = 49, 1/50
S = 1 + eps
print(f'k={k} eps=1/50: 论文上界 = {k*S*np.log(k)/(k-1):.6f}')
for p in [0.5, 0.8, 1.0, 1.2, 1.5, 2.0, 2.5, 3.0, 4.0]:
    b, x = opt_family(p, k, S)
    flag = ' <4!!' if b < 4 else ''
    print(f'p={p}: 上界 {b:.6f} (x={x[0]:.5f}, y={x[1]:.5f}){flag}')
