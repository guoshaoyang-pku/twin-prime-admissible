#!/usr/bin/env python3
"""resid_check.py — 逐点残差 r(t) = int F_N dt1 - lam*F_N 与移位上界快速估计"""
import numpy as np, sys
sys.path.insert(0, '.')
k = 49; D = 27; en, ed = 1, 25
eps = en/ed
v = np.load(f'ev_k{k}_d{D}_eps{en}_{ed}.npy')
lam = 0.081368920319953

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

def F(t):
    P1 = t.sum(); u = 1 + eps - P1
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

GL, GW = np.polynomial.legendre.leggauss(24)
def intF(t, i):
    T = 1 + eps - (t.sum() - t[i])
    if T <= 0: return 0.0
    pts = 0.5*(GL+1)*T
    vals = np.array([F(np.concatenate([t[:i],[p],t[i+1:]])) for p in pts])
    return 0.5*T*np.dot(GW, vals)

rng = np.random.default_rng(9)
worst = (0, None)
for it in range(120):
    t = rng.dirichlet(np.ones(k))*(1+eps)*rng.uniform(0.2, 1)
    fv = F(t)
    if fv < 1e-12: continue
    r_sum = sum(intF(t, i) for i in range(k)) - k*lam*fv
    rel = r_sum / fv
    if rel > worst[0]: worst = (rel, t)
print(f'120 采样: max (Σ∫F - kλF)/F = {worst[0]:.6f}  (kλ = {k*lam:.4f}, 需要 < {4 - k*lam:.4f})')
print(f'移位上界估计: kλ + {worst[0]:.6f} = {k*lam + worst[0]:.6f} {"<4!!!" if k*lam+worst[0] < 4 else ""}')
