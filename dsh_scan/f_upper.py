#!/usr/bin/env python3
"""f_upper.py — |F| 的 CS 上界: sup_t sum_i int |F| dt_i / |F(t)|
G_i = |F|/int|F| dt_i 正且 int G_i = 1 (合法) => 无限维上界
"""
import numpy as np, sys, time
from scipy.optimize import minimize
sys.path.insert(0, '.')

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
eps = en / ed

v = np.load(f'ev_k{k}_d{D}_eps{en}_{ed}.npy')
n = len(v)

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
    for r in range(0, D - sum(gamma) + 1):
        pass
for gamma in parts_all:
    maxr = D - sum(gamma) + 1
    gamma_coeffs[gamma] = [0.0] * maxr
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

def F(t):
    P1 = t.sum()
    u = 1 + eps - P1
    if u <= 0: return 0.0
    tot = 0.0
    for gamma, coeffs in gamma_coeffs.items():
        pg = p_gamma(t, gamma)
        if pg == 0: continue
        val = 0.0
        for c in reversed(coeffs):
            val = val * u + c
        tot += pg * val
    return tot

# Gauss-Legendre 20 点 on [0,1]
GL, GW = np.polynomial.legendre.leggauss(20)

def int_abs_F(t, i):
    """int_0^{T_i} |F(t)| dt_i, T_i = 1+eps - sum_{j!=i} t_j"""
    T = 1 + eps - (t.sum() - t[i])
    if T <= 0: return 0.0
    pts = 0.5 * (GL + 1) * T
    acc = 0.0
    for tp in pts:
        tt = t.copy(); tt[i] = tp
        acc += abs(F(tt))
    return 0.5 * T * np.sum(GW) * (acc / 20)  # 权重平均

def int_abs_F_vec(t, i):
    T = 1 + eps - (t.sum() - t[i])
    if T <= 0: return 0.0
    pts = 0.5 * (GL + 1) * T
    vals = np.array([abs(F(np.concatenate([t[:i], [p], t[i+1:]]))) for p in pts])
    return 0.5 * T * np.dot(GW, vals)

def obj(t):
    fv = abs(F(t))
    if fv < 1e-300: return 1e9
    s = 0.0
    for i in range(k):
        s += int_abs_F_vec(t, i)
    return s / fv

rng = np.random.default_rng(3)
t0 = time.time()
best = 1e9
for it in range(12):
    u = rng.dirichlet(np.ones(k)) * (1 + eps)
    res = minimize(obj, u, method='SLSQP', bounds=[(0, 1+eps)]*k,
                   constraints={'type': 'ineq', 'fun': lambda t: 1 + eps - np.sum(t)},
                   options={'maxiter': 20, 'ftol': 1e-8})
    if res.fun < best:
        best = res.fun
    print(f'  start {it}: {res.fun:.4f} ({time.time()-t0:.0f}s)', flush=True)
print(f'|F| CS 上界: {best:.6f}  {"<4!!!" if best < 4 else ""}')
