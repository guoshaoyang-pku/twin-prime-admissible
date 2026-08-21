#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""mixed_scan.py — 论文等价基: {(1-P1)^r · p_γ : r + deg(γ) ≤ D, γ 偶数划分}
矩阵公式 (对应论文 Lemma bfi 的幂和等价形式):
  I[(r1,α),(r2,β)] = (1+ε)^{k+deg+r1+r2} · (r1+r2)! · H(γ;k) / (k+r1+r2+deg)!
  J1 同 floatbuild 公式, s = r1+r2+2+Sa+Sb, Ba = r1!·Sa!/(r1+Sa+1)!
用法: python3 mixed_scan.py k eps_num eps_den D
"""
import sys, time, math
sys.path.insert(0, '.')
import floatbuild as fb
from floatbuild import multiset_key, H_of_float, split_a, float_lambda_max

def gen_even_partitions(max_deg):
    """偶数 part 划分 (非增元组), 总度数 ≤ max_deg"""
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def main():
    t0 = time.time()
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3]); D = int(sys.argv[4])
    eps = en / ed
    parts = gen_even_partitions(D)
    basis = []  # (r, gamma)
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    n = len(basis)
    print(f"k={k} eps={en}/{ed} D={D} mixed-basis n={n}", flush=True)
    t1 = time.time()
    H_cache = {}
    for coords in (k, k - 1):
        for gamma in parts:
            H_of_float(list(gamma), coords, H_cache)
        for gamma in parts:
            for delta in parts:
                H_of_float(list(sorted(gamma + delta)), coords, H_cache)
    print(f"H cache built ({time.time()-t1:.0f}s, {len(H_cache)} entries)", flush=True)
    fac = {m: math.factorial(m) for m in range(0, 2 * D + 100)}
    c1, c2 = 1.0 - eps, 2.0 * eps
    one_eps = 1.0 + eps
    eppow = [1.0]
    for _ in range(k + 2 * D + 10):
        eppow.append(eppow[-1] * one_eps)
    G_cache = {}
    def G(s, deg):
        key = (s, deg)
        v = G_cache.get(key)
        if v is not None:
            return v
        tot = 0.0
        for j in range(s + 1):
            tot += math.comb(s, j) * c1 ** j * c2 ** (s - j) * fac[j] / fac[k - 1 + j + deg]
        G_cache[key] = tot
        return tot
    splits = {gamma: split_a(list(gamma)) for gamma in parts}
    t2 = time.time()
    I = [[0.0] * n for _ in range(n)]
    J1 = [[0.0] * n for _ in range(n)]
    for ia, (r1, alpha) in enumerate(basis):
        for ib, (r2, beta) in enumerate(basis):
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            rr = r1 + r2
            I[ia][ib] = eppow[k + deg + rr] * fac[rr] * H_of_float(list(gamma), k, H_cache) / fac[k + rr + deg]
            tot = 0.0
            for ca, Sa, ga in splits[alpha]:
                Ba = fac[r1] * fac[Sa] / fac[r1 + Sa + 1]
                for cb, Sb, gb in splits[beta]:
                    Bb = fac[r2] * fac[Sb] / fac[r2 + Sb + 1]
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    dmu = sum(mu)
                    s = rr + 2 + Sa + Sb
                    tot += ca * cb * Ba * Bb * (c1 ** (k - 1 + dmu)) * H_of_float(list(mu), k - 1, H_cache) * G(s, dmu)
            J1[ia][ib] = tot
    print(f"matrices built ({time.time()-t2:.0f}s)", flush=True)
    lam = float_lambda_max(I, J1)
    M = k * lam
    print(f"RESULT k={k} eps={en}/{ed} D={D}: lambda={lam:.6f} M ~= {M:.6f}  (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
