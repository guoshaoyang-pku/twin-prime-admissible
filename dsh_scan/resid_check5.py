"""resid_check4.py — 300 点残差采样 (每 30 点打印, 单点 40s 超时保护)"""
import numpy as np, sys, signal
sys.path.insert(0, '.')
k = 49; D = 27; eps = 1/25
v = np.load(f'ev_k{k}_d{D}_eps1_25_Inorm.npy')
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

class TO(Exception): pass
def handler(s, f): raise TO()
signal.signal(signal.SIGALRM, handler)

rng = np.random.default_rng(21)
worst = -1e9; worst_f = 1e9; fmin = 1e9; nskip = 0
results = []
for it in range(300):
    u = rng.dirichlet(np.ones(k)) * (1+eps)
    if it % 4 == 0:
        u *= rng.uniform(0.05, 0.6)
    signal.alarm(40)
    try:
        fv = F(u)
        if fv < 1e-15: signal.alarm(0); continue
        r_sum = sum(intF(u, i) for i in range(k)) - k*lam*fv
        rel = r_sum / fv
    except TO:
        nskip += 1; signal.alarm(0); continue
    signal.alarm(0)
    fmin = min(fmin, fv)
    if rel > worst:
        worst = rel
    results.append(rel)
    if (it+1) % 30 == 0:
        print(f'  {it+1}/300: worst={worst:.6f} fmin={fmin:.3e} skip={nskip}', flush=True)
print(f'完成: 300 点, worst max(Σ∫F-kλF)/F = {worst:.6f}, fmin={fmin:.3e}, skip={nskip}')
print(f'上界估计 = {k*lam + worst:.6f} {"<4!!!" if k*lam+worst < 4 else ""}')
