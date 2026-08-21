import sys, math, time
sys.path.insert(0, '.')
import numpy as np
from mixed_scan import gen_even_partitions
import floatbuild as fb
from floatbuild import multiset_key, H_of_float, split_a

def build(k, eps, D):
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    n = len(basis)
    H_cache = {}
    for coords in (k, k - 1):
        for gamma in parts:
            H_of_float(list(gamma), coords, H_cache)
        for gamma in parts:
            for delta in parts:
                H_of_float(list(sorted(gamma + delta)), coords, H_cache)
    fac = {m: math.factorial(m) for m in range(0, 2*D+100)}
    c1, c2 = 1.0-eps, 2.0*eps
    one_eps = 1.0+eps
    eppow = [1.0]
    for _ in range(k + 2*D + 10): eppow.append(eppow[-1]*one_eps)
    G_cache = {}
    def G(s, deg):
        key = (s, deg)
        if key in G_cache: return G_cache[key]
        tot = 0.0
        for j in range(s+1):
            tot += math.comb(s,j)*c1**j*c2**(s-j)*fac[j]/fac[k-1+j+deg]
        G_cache[key] = tot
        return tot
    splits = {gamma: split_a(list(gamma)) for gamma in parts}
    I = np.zeros((n,n)); J1 = np.zeros((n,n))
    for ia,(r1,alpha) in enumerate(basis):
        for ib,(r2,beta) in enumerate(basis):
            gamma = multiset_key(tuple(sorted(alpha+beta)))
            deg = sum(gamma); rr = r1+r2
            I[ia,ib] = eppow[k+deg+rr]*fac[rr]*H_of_float(list(gamma),k,H_cache)/fac[k+rr+deg]
            tot = 0.0
            for ca,Sa,ga in splits[alpha]:
                Ba = fac[r1]*fac[Sa]/fac[r1+Sa+1]
                for cb,Sb,gb in splits[beta]:
                    Bb = fac[r2]*fac[Sb]/fac[r2+Sb+1]
                    mu = multiset_key(tuple(sorted(ga+gb)))
                    dmu = sum(mu)
                    s = rr+2+Sa+Sb
                    tot += ca*cb*Ba*Bb*(c1**(k-1+dmu))*H_of_float(list(mu),k-1,H_cache)*G(s,dmu)
            J1[ia,ib] = tot
    return I, J1

for (k, eps, D) in [(54, 0.0, 23), (50, 1/25, 27)]:
    I, J1 = build(k, eps, D)
    print(f"k={k} eps={eps} D={D}: cond(I)={np.linalg.cond(I):.2e} cond(J1)={np.linalg.cond(J1):.2e} n={len(I)}")
