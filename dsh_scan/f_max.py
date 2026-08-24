"""找 F 的峰值 (D=27 特征函数)"""
import numpy as np, sys
from scipy.optimize import minimize
sys.path.insert(0, '.')
k, D, eps = 49, 27, 1/25
v = np.load('ev_k49_d27_eps1_25.npy')
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
rng = np.random.default_rng(0)
best = (-1e9, None)
for it in range(10):
    t0 = rng.dirichlet(np.ones(k)) * (1+eps) * rng.uniform(0.1, 1)
    res = minimize(lambda t: -F(t), t0, method='SLSQP', bounds=[(0, 1+eps)]*k,
                   constraints={'type':'ineq','fun':lambda t: 1+eps-np.sum(t)},
                   options={'maxiter': 20, 'ftol': 1e-10})
    if -res.fun > best[0]:
        best = (-res.fun, res.x.copy())
print(f'F 峰值 ≈ {best[0]:.6e}  (t 前3: {best[1][:3]}, Σt={best[1].sum():.4f})')
print(f'u = 1+eps-Σt = {1+eps-best[1].sum():.4f}')
