#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""eps_scan.py — 快速多 ε 扫描 (浮点): 固定 (k, D), 一次预计算, 对多个 ε 求 M_{k,ε} ≈ k·λ_max
基 (论文等价): {(1+ε-P1)^r · p_γ : r+deg(γ)≤D, γ 偶数划分}
  I[(r1,α),(r2,β)] = (1+ε)^{k+deg+rr} · rr! · H(γ;k)/(k+rr+deg)!
  J1 = Σ_split_pairs ca·cb·Ba·Bb · (1-ε)^{k-1+dμ} · G(s,dμ),  G(s,deg)=Σ_j C(s,j)(1-ε)^j(2ε)^{s-j} j!/(k-1+j+deg)!
用法: python3 eps_scan.py k D eps1 eps2 ...   (eps 形如 num/den 或浮点)
"""
import sys, time, math
sys.path.insert(0, '.')
from floatbuild import multiset_key, H_of_float, split_a, float_lambda_max

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def parse_eps(s):
    if '/' in s:
        a, b = s.split('/')
        return int(a) / int(b)
    return float(s)

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    eps_list = [parse_eps(s) for s in sys.argv[3:]]
    if not eps_list:
        eps_list = [1/64, 1/50, 1/40, 1/32, 1/25, 1/20, 1/16, 1/12, 1/10, 1/8, 1/6, 1/5, 1/4]
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    n = len(basis)
    print(f"eps_scan k={k} D={D} n={n} eps={eps_list}", flush=True)
    t1 = time.time()
    H_cache = {}
    for coords in (k, k - 1):
        for gamma in parts:
            H_of_float(list(gamma), coords, H_cache)
        for gamma in parts:
            for delta in parts:
                H_of_float(list(sorted(gamma + delta)), coords, H_cache)
    print(f"H cache ({time.time()-t1:.0f}s, {len(H_cache)} entries)", flush=True)
    fac = {m: math.factorial(m) for m in range(0, 2 * D + 100)}
    splits = {gamma: split_a(list(gamma)) for gamma in parts}
    # 预计算 ε 无关部分:
    # Icoef[ia][ib] = rr!·H(γ;k)/fac[k+rr+deg], Iexp[ia][ib] = k+deg+rr
    # Jterms[ia][ib] = [(coeff, p1, s, dmu)] 其中 coeff = ca·cb·Ba·Bb·H(μ;k-1),
    #   贡献 = coeff · (1-ε)^{k-1+dmu} · G(s,dmu)
    t2 = time.time()
    Icoef = [[0.0]*n for _ in range(n)]
    Iexp  = [[0]*n for _ in range(n)]
    Jterms = [[None]*n for _ in range(n)]
    for ia, (r1, alpha) in enumerate(basis):
        for ib, (r2, beta) in enumerate(basis):
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            rr = r1 + r2
            Icoef[ia][ib] = fac[rr] * H_of_float(list(gamma), k, H_cache) / fac[k + rr + deg]
            Iexp[ia][ib] = k + deg + rr
            tlst = []
            for ca, Sa, ga in splits[alpha]:
                Ba = fac[r1] * fac[Sa] / fac[r1 + Sa + 1]
                for cb, Sb, gb in splits[beta]:
                    Bb = fac[r2] * fac[Sb] / fac[r2 + Sb + 1]
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    dmu = sum(mu)
                    s = rr + 2 + Sa + Sb
                    tlst.append((ca * cb * Ba * Bb * H_of_float(list(mu), k - 1, H_cache),
                                 k - 1 + dmu, s, dmu))
            Jterms[ia][ib] = tlst
    print(f"terms precomputed ({time.time()-t2:.0f}s)", flush=True)
    # G 表: Gtab[(s,dmu)] = Σ_j C(s,j)(1-ε)^j(2ε)^{s-j} j!/(k-1+j+dmu)!
    results = []
    for eps in eps_list:
        t3 = time.time()
        c1, c2 = 1.0 - eps, 2.0 * eps
        e1 = 1.0 + eps
        maxp = k + 3 * D + 5
        c1p = [1.0]; c2p = [1.0]; e1p = [1.0]
        for _ in range(maxp):
            c1p.append(c1p[-1] * c1); c2p.append(c2p[-1] * c2); e1p.append(e1p[-1] * e1)
        Gtab = {}
        for s in range(0, 2 * D + 3):
            for dmu in range(0, 2 * D + 1):
                tot = 0.0
                for j in range(s + 1):
                    tot += math.comb(s, j) * c1p[j] * c2p[s - j] * fac[j] / fac[k - 1 + j + dmu]
                Gtab[(s, dmu)] = tot
        I = [[0.0]*n for _ in range(n)]
        J1 = [[0.0]*n for _ in range(n)]
        for ia in range(n):
            for ib in range(n):
                I[ia][ib] = e1p[Iexp[ia][ib]] * Icoef[ia][ib]
                tot = 0.0
                for (coef, p1, s, dmu) in Jterms[ia][ib]:
                    tot += coef * c1p[p1] * Gtab[(s, dmu)]
                J1[ia][ib] = tot
        lam = float_lambda_max(I, J1)
        M = k * lam
        results.append((eps, lam, M))
        print(f"  eps={eps:g}: lambda={lam:.8f} M={M:.6f} ({time.time()-t3:.0f}s)", flush=True)
    print(f"SUMMARY k={k} D={D}: " + " | ".join(f"eps={e:g}->M={m:.6f}" for e, l, m in results), flush=True)
    print(f"total {time.time()-t0:.0f}s", flush=True)

if __name__ == '__main__':
    main()
