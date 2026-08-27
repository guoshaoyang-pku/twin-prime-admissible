#!/usr/bin/env python3
"""shift_upper2.py — 移位特征函数 CS 上界 (bfi_fast 加速)
F' = F + delta, G_i = F'/int F'  =>  上界 = sup_t sum_i (intF_i + delta*u_i) / (F + delta)
若 F' > 0 且上界 < 4 => M_{49,1/25} < 4 无限维严格证明!
"""
import numpy as np, sys
from scipy.optimize import minimize
sys.path.insert(0, '.')
import bfi_fast as BF
k, D, eps = BF.k, BF.D, BF.eps

def F(t):
    P1 = t.sum(); u = 1 + eps - P1
    if u <= 0: return 0.0
    tot = 0.0
    for gamma, coeffs in BF.gamma_coeffs.items():
        m = len(gamma)
        if m == 0:
            val = 0.0
            for c in reversed(coeffs):
                val = val * u + c
            tot += val
            continue
        pg = BF.p_subsets(t, gamma)[-1]
        if pg == 0: continue
        val = 0.0
        for c in reversed(coeffs):
            val = val * u + c
        tot += pg * val
    return tot

def upper_at(t, delta):
    fv = F(t)
    s = 0.0
    for i in range(k):
        s += (BF.intF_fast(t, i) + delta * (1 + eps - (t.sum() - t[i])))
    return s / (fv + delta)

def F_range(nsamp=60):
    rng = np.random.default_rng(0)
    mn, mx = 1e300, -1e300
    for _ in range(nsamp):
        t = rng.dirichlet(np.ones(k)) * (1+eps)
        f = F(t)
        if f < mn: mn = f
        if f > mx: mx = f
    return mn, mx

def sup_upper(delta, nstart=6):
    rng = np.random.default_rng(3)
    best = -1e9
    for it in range(nstart):
        t0 = rng.dirichlet(np.ones(k)) * (1+eps) * rng.uniform(0.2, 1)
        res = minimize(lambda t: -upper_at(t, delta), t0, method='SLSQP',
                       bounds=[(0, 1+eps)]*k,
                       constraints={'type':'ineq','fun':lambda t: 1+eps-np.sum(t)},
                       options={'maxiter': 12, 'ftol': 1e-8})
        if -res.fun > best: best = -res.fun
    return best

mn, mx = F_range()
print(f'F 范围 (采样60): [{mn:.3e}, {mx:.3e}]')
rng2 = np.random.default_rng(0)
# 负部深度: 更多采样找 min
fmin = 1e300
for _ in range(200):
    t = rng2.dirichlet(np.ones(k)) * (1+eps)
    f = F(t)
    if f < fmin: fmin = f
print(f'F min (200采样): {fmin:.3e}')
# delta 扫描: 相对负部
for delta in [0.0, 0.1, 0.5, 1.0, 2.0, 5.0, 10.0, 50.0]:
    d = delta * max(-fmin, 1e-30) if fmin < 0 else delta
    ub = sup_upper(d, 4)
    print(f'delta={d:.2e}: 上界={ub:.6f} {"<4!!!" if ub < 4 else ""}', flush=True)
