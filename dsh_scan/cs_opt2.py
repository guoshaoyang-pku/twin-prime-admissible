#!/usr/bin/env python3
"""cs_opt2.py — 族 g(s) = (as+b)^{-p}, 优化 a,b 使无限维上界最小
凹 (p<1): sup = k*(aS+b)^p (均匀点); 凸 (p>1): sup = (akS+b)^p + (k-1)b^p (顶点)
约束: int_{s0}^{k s0} (as+b)^{-p} ds <= k-1 对所有 s0 in [0,S], S=1+eps
"""
import numpy as np
from scipy.optimize import minimize_scalar

def bound_concave(p, r, k, S):
    """p<1: 上界 = k*a^p*(S+r)^p; a 由约束确定"""
    # a^{1-p}[(kS+r)^{1-p} - (S+r)^{1-p}]/(1-p) = k-1
    num = (k*S + r)**(1-p) - (S + r)**(1-p)
    a = ((k - 1) * (1 - p) / num) ** (1/(1-p))
    return k * a**p * (S + r)**p

def bound_convex(p, r, k, S):
    """p>1: 上界 = (akS+b)^p + (k-1)b^p = a^p[(kS+r)^p + (k-1)r^p]"""
    num = (k*S + r)**(1-p) - (S + r)**(1-p)  # 负
    a = ((k - 1) * (p - 1) / (-num)) ** (1/(p-1))
    return a**p * ((k*S + r)**p + (k - 1)*r**p)

k, eps = 49, 1/50
S = 1 + eps
print(f'k={k} eps=1/50 S={S}: 论文上界 = {k*S*np.log(k)/(k-1):.6f}')
print('--- 凹族 (p<1) ---')
for p in [0.95, 0.9, 0.8, 0.7, 0.5, 0.3, 0.1]:
    best = (1e9, None)
    for r in np.logspace(-6, 6, 60):
        try:
            b = bound_concave(p, r, k, S)
            if b < best[0]: best = (b, r)
        except Exception: pass
    print(f'p={p}: 最小上界 {best[0]:.6f} (r={best[1]:.4f}) {"<4!!" if best[0] < 4 else ""}')
print('--- 凸族 (p>1) ---')
for p in [1.05, 1.1, 1.2, 1.5, 2.0]:
    best = (1e9, None)
    for r in np.logspace(-6, 6, 60):
        try:
            b = bound_convex(p, r, k, S)
            if b < best[0]: best = (b, r)
        except Exception: pass
    print(f'p={p}: 最小上界 {best[0]:.6f} (r={best[1]:.4f}) {"<4!!" if best[0] < 4 else ""}')
