"""bfi_fast vs Gauss 对照 (同 v2)"""
import numpy as np, sys, math
sys.path.insert(0, '.')
import bfi_fast as BF
k, D, eps = 49, 27, 1/25
v2 = np.load('ev_k49_d27_eps1_25_Inorm.npy')

# Gauss 对照的 F (用 BF 的 gamma_coeffs)
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

GL, GW = np.polynomial.legendre.leggauss(28)
def gauss_intF(t, i):
    u0 = 1 + eps - (t.sum() - t[i])
    pts = 0.5*(GL+1)*u0
    vals = np.array([F(np.concatenate([t[:i],[p],t[i+1:]])) for p in pts])
    return 0.5*u0*np.dot(GW, vals)

rng = np.random.default_rng(3)
for it in range(2):
    t = rng.dirichlet(np.ones(k)) * (1+eps) * rng.uniform(0.3, 1)
    b = BF.intF_fast(t, 0)
    g = gauss_intF(t, 0)
    fv = F(t)
    print(f'点{it}: bfi_fast={b:.6e} gauss={g:.6e} 相对差={abs(b-g)/max(abs(g),1e-30):.2e}  F={fv:.4e}')
