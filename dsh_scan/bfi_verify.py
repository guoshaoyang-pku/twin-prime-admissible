"""bfi vs Gauss 对照 (3 个随机点)"""
import numpy as np, math, sys
sys.path.insert(0, '.')
k, D, eps = 49, 27, 1/25
v = np.load(f'ev_k{k}_d{D}_eps1_25.npy')
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
basis = [(r, g) for g in parts_all for r in range(0, D - sum(g) + 1)]
gamma_coeffs = {}
for gamma in parts_all:
    gamma_coeffs[gamma] = [0.0] * (D - sum(gamma) + 1)
for (r, gamma), vi in zip(basis, v):
    gamma_coeffs[gamma][r] += vi

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

def subsets_parts(gamma):
    m = len(gamma)
    res = []
    for mask in range(1 << m):
        s_sum = 0; s_len = 0; rest = []
        for j in range(m):
            if mask >> j & 1:
                s_sum += gamma[j]; s_len += 1
            else:
                rest.append(gamma[j])
        res.append((s_sum, s_len, tuple(rest)))
    return res

def bfi_intF(t):
    u0 = 1 + eps - sum(t[1:])
    tot = 0.0
    for idx, (r, gamma) in enumerate(basis):
        vi = v[idx]
        if vi == 0: continue
        for (a_sum, m, rest) in subsets_parts(gamma):
            c = math.factorial(r)*math.factorial(a_sum)/math.factorial(r+a_sum+1)
            pg = p_gamma(np.concatenate([[0.0], t[1:]]), rest)
            tot += vi * c * u0**(r+m+1) * pg
    return tot

GL, GW = np.polynomial.legendre.leggauss(28)
def gauss_intF(t):
    u0 = 1 + eps - sum(t[1:])
    pts = 0.5*(GL+1)*u0
    vals = np.array([F(np.concatenate([[p], t[1:]])) for p in pts])
    return 0.5*u0*np.dot(GW, vals)

rng = np.random.default_rng(5)
for it in range(3):
    t = rng.dirichlet(np.ones(k)) * (1+eps) * rng.uniform(0.3, 1)
    b = bfi_intF(t); g = gauss_intF(t)
    print(f'点{it}: bfi={b:.8f} gauss={g:.8f} 差={abs(b-g):.2e}  F(t)={F(t):.6f}')
