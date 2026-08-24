#!/usr/bin/env python3
"""resid_check2.py — 2000 点残差扫描 (含 F 小区域) — sup (sum intF - k lam F)/F"""
import numpy as np, sys
sys.path.insert(0, '.')
k = 49; D = 27; eps = 1/25
v = np.load(f'ev_k{k}_d{D}_eps1_25.npy')
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

GL, GW = np.polynomial.legendre.leggauss(16)
def intF(t, i):
    T = 1 + eps - (t.sum() - t[i])
    if T <= 0: return 0.0
    pts = 0.5*(GL+1)*T
    vals = np.array([F(np.concatenate([t[:i],[p],t[i+1:]])) for p in pts])
    return 0.5*T*np.dot(GW, vals)

rng = np.random.default_rng(11)
worst = (-1e9, None, None)
fmin = 1e9
for it in range(400):
    # 混合采样: 常规 + 边界 (F 小区域)
    u = rng.dirichlet(np.ones(k))*(1+eps)
    if it % 3 == 0:
        u *= rng.uniform(0.05, 0.5)  # 边界附近 (u=1+eps-sum t 大? 或小)
    fv = F(u)
    if fv < 1e-15: continue
    fmin = min(fmin, fv)
    r_sum = sum(intF(u, i) for i in range(k)) - k*lam*fv
    rel = r_sum / fv
    if rel > worst[0]:
        worst = (rel, u.copy(), fv)
print(f'400 点 (含边界): min F = {fmin:.3e}')
print(f'max (Σ∫F-kλF)/F = {worst[0]:.6f}')
print(f'上界估计 = {k*lam + worst[0]:.6f} {"<4!!!" if k*lam+worst[0] < 4 else ""}')
