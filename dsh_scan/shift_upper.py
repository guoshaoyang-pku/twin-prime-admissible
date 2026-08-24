#!/usr/bin/env python3
"""shift_upper.py — 移位特征函数 CS 上界: F' = F_N + delta*1, G_i = F'/int F'
若 F' > 0 且上界 < 4 => M_{k,eps} < 4 无限维严格证明!
上界 = sup_t sum_i int F'(t) dt_i / F'(t)
"""
import numpy as np, sys
from scipy.optimize import minimize
sys.path.insert(0, '.')

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
eps = en / ed
v = np.load(f'ev_k{k}_d{D}_eps{en}_{ed}.npy')

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for x in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + x, parts + [x])
    rec(0, [])
    return res

parts_all = gen_even_partitions(D)
gamma_coeffs = {}
for gamma in parts_all:
    gamma_coeffs[gamma] = [0.0] * (D - sum(gamma) + 1)
idx = 0
for gamma in parts_all:
    for r in range(0, D - sum(gamma) + 1):
        gamma_coeffs[gamma][r] = v[idx]; idx += 1

def p_gamma(t, gamma):
    m = len(gamma)
    if m == 0: return 1.0
    size = 1 << m
    state = np.zeros(size); state[0] = 1.0
    for ti in t:
        if ti <= 0: continue
        pw = np.array([ti ** g for g in gamma])
        new = state.copy()
        for j in range(m):
            idx0 = np.where((np.arange(size) & (1 << j)) == 0)[0]
            new[idx0 | (1 << j)] += state[idx0] * pw[j]
        state = new
    return state[-1]

def F(t, delta):
    P1 = t.sum()
    u = 1 + eps - P1
    if u <= 0: return delta  # F_N = 0 在支撑外, F' = delta
    tot = 0.0
    for gamma, coeffs in gamma_coeffs.items():
        pg = p_gamma(t, gamma)
        if pg == 0: continue
        val = 0.0
        for c in reversed(coeffs):
            val = val * u + c
        tot += pg * val
    return tot + delta

GL, GW = np.polynomial.legendre.leggauss(24)

def int_F(t, i, delta):
    T = 1 + eps - (t.sum() - t[i])
    if T <= 0: return delta * T
    pts = 0.5 * (GL + 1) * T
    vals = np.array([F(np.concatenate([t[:i], [p], t[i+1:]]), delta) for p in pts])
    return 0.5 * T * np.dot(GW, vals)

def upper_at(t, delta):
    fv = F(t, delta)
    s = 0.0
    for i in range(k):
        s += int_F(t, i, delta)
    return s / fv

def min_F(delta, nsamp=300):
    rng = np.random.default_rng(0)
    mn = 1e9
    for _ in range(nsamp):
        u = rng.dirichlet(np.ones(k)) * (1 + eps)
        mn = min(mn, F(u, delta))
    return mn

def sup_upper(delta, nstart=8):
    rng = np.random.default_rng(3)
    best = -1
    for it in range(nstart):
        t0 = rng.dirichlet(np.ones(k)) * (1 + eps) * rng.uniform(0.3, 1)
        res = minimize(lambda t: -upper_at(t, delta), t0, method='SLSQP',
                       bounds=[(0, 1+eps)]*k,
                       constraints={'type': 'ineq', 'fun': lambda t: 1+eps-np.sum(t)},
                       options={'maxiter': 15, 'ftol': 1e-8})
        if -res.fun > best: best = -res.fun
    return best

# 找最小 delta 使 F' > 0, 然后测试上界
for delta in [0.0, 1e-6, 1e-4, 1e-3, 1e-2, 0.05, 0.1]:
    mf = min_F(delta, 500)
    ub = sup_upper(delta, 6)
    print(f'delta={delta}: min F\'={mf:.4e} 上界={ub:.4f} {"<4!!!" if ub < 4 and mf > 0 else ""}')
