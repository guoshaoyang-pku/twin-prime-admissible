#!/usr/bin/env python3
"""cs_2var.py — 两变量 G_i(t) = C * u^{-a} * s_i^{-b}, u = 1+eps-sum t, s_i = u + k*t_i
约束: int_0^{u0} C (u0-t)^{-a} (u0+(k-1)t)^{-b} dt <= 1 对所有 u0 in [0,S]
     = C * u0^{1-a-b} * I(a,b) <= 1,  I = int_0^1 (1-x)^{-a} (1+(k-1)x)^{-b} dx
上界: sup_t sum_i u(t)^a s_i(t)^b / C
"""
import numpy as np
from scipy.integrate import quad
from scipy.optimize import minimize

def I_ab(a, b, k):
    return quad(lambda x: (1-x)**(-a) * (1+(k-1)*x)**(-b), 0, 1, limit=100)[0]

def upper_for(a, b, k, S, nstart=20, seed=7):
    if a + b >= 1: return None
    I = I_ab(a, b, k)
    C = 1.0 / (S**(1-a-b) * I)
    rng = np.random.default_rng(seed)
    best = -1
    for it in range(nstart):
        t = rng.dirichlet(np.ones(k)) * S
        def obj(tt):
            u = S - tt.sum()
            if u <= 0: return 1e9
            s = u + k * tt
            return -np.sum(u**a * s**b) / C
        cons = ({'type': 'ineq', 'fun': lambda tt: S - np.sum(tt)})
        res = minimize(obj, t, method='SLSQP', bounds=[(0, S)]*k,
                       constraints=cons, options={'maxiter': 30, 'ftol': 1e-10})
        if -res.fun > best:
            best = -res.fun
    return best

k, S = 49, 1.02
paper = k * S * np.log(k) / (k - 1)
print(f'k=49 eps=1/50: 论文上界 {paper:.6f}')
print('扫描 (a, b) 两变量族:')
for a in [0.0, 0.1, 0.2, 0.3, 0.4]:
    for b in [0.0, 0.1, 0.2, 0.3, 0.4, 0.5]:
        if a + b >= 1: continue
        ub = upper_for(a, b, k, S, nstart=12)
        if ub is None: continue
        flag = ' <4!!' if ub < 4 else ''
        print(f'  a={a} b={b}: 上界 {ub:.4f}{flag}')
