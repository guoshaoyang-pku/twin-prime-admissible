#!/usr/bin/env python3
"""cs_opt3.py — 族 g(s) = (as+b)^p (p>0): 1/g 凸 -> sup 在顶点
上界 = (akS+b)^{-p} + (k-1)b^{-p}, S=1+eps
约束: ((akS+b)^{p+1}-(aS+b)^{p+1}) <= a(p+1)S(k-1)  (s0=S 最坏)
"""
import numpy as np
from scipy.optimize import minimize

def upper(p, x, y, k, S):
    """x = a*S, y = b: 上界 = (kx+y)^{-p} + (k-1)y^{-p}"""
    return (k*x + y)**(-p) + (k - 1) * y**(-p)

def feasible(p, x, y, k, S):
    """约束: ((kx+y)^{p+1}-(x+y)^{p+1}) <= x(p+1)(k-1)"""
    lhs = (k*x + y)**(p+1) - (x + y)**(p+1)
    rhs = x * (p + 1) * (k - 1)
    return lhs <= rhs + 1e-12

def opt_family(p, k, S):
    best = (1e9, None)
    for x0 in np.logspace(-3, 3, 25):
        for y0 in np.logspace(-3, 3, 25):
            if not feasible(p, x0, y0, k, S):
                continue
            def obj(v):
                x, y = v
                if x <= 0 or y <= 0: return 1e9
                if not feasible(p, x, y, k, S): return 1e9
                return upper(p, x, y, k, S)
            res = minimize(obj, [x0, y0], method='Nelder-Mead',
                          options={'maxiter': 300, 'xatol': 1e-12, 'fatol': 1e-14})
            if res.fun < best[0] and res.fun < 1e8:
                best = (res.fun, res.x)
    return best

k, eps = 49, 1/50
S = 1 + eps
print(f'k={k} eps=1/50: 论文上界 = {k*S*np.log(k)/(k-1):.6f}')
for p in [0.5, 0.7, 0.9, 1.0, 1.2, 1.5, 2.0, 3.0]:
    b, x = opt_family(p, k, S)
    flag = ' <4!!' if b < 4 else ''
    print(f'p={p}: 上界 {b:.6f} (x={x[0]:.4f}, y={x[1]:.4f}){flag}')
