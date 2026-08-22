#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_e0.py — 重新生成 ε=0 的 (I, J1) 精确有理矩阵 (k, D), 存到
frac_cache_{k}_{D}_e0.pkl (不覆盖共享的 frac_cache_{k}_{D}.pkl;
该文件已被并发的 ε=1/50 会话覆盖)。公式与 fraction_mixed.py (eps=0) 完全一致。
用法: python3 build_e0.py k D
"""
import sys, time, math, pickle
from fractions import Fraction as Fr

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def multiset_key(parts):
    return tuple(sorted(parts))

def H_exact(parts, coords, cache):
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    dp = {(): Fr(1)}
    for v in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx in range(len(state)):
                if idx > 0 and state[idx - 1] == state[idx]:
                    continue
                mult = state.count(state[idx])
                ns = list(state); ns[idx] += v; ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, Fr(0)) + cnt * mult
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, Fr(0)) + cnt
        dp = ndp
    val = Fr(0)
    for state, cnt in dp.items():
        if len(state) <= coords:
            f = math.factorial(coords) // math.factorial(coords - len(state))
            val += cnt * math.prod(math.factorial(s_) for s_ in state) * f
    cache[key] = val
    return val

def split_a(parts):
    from collections import Counter
    cnt = Counter(parts)
    res = []
    vals = sorted(cnt)
    def rec(i, chosen, S, rest):
        if i == len(vals):
            res.append((math.prod(math.comb(cnt[v], j) for v, j in chosen), S, multiset_key(rest)))
            return
        v = vals[i]
        for j in range(cnt[v] + 1):
            rec(i + 1, chosen + [(v, j)], S + j * v, rest + [v] * (cnt[v] - j))
    rec(0, [], 0, [])
    return res

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    eps = Fr(0)
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    n = len(basis)
    print(f"build_e0 k={k} eps=0 D={D} n={n}", flush=True)
    H_cache = {}
    for coords in (k, k - 1):
        for gamma in parts:
            H_exact(list(gamma), coords, H_cache)
        for gamma in parts:
            for delta in parts:
                H_exact(list(sorted(gamma + delta)), coords, H_cache)
    fac = {m: math.factorial(m) for m in range(0, 2 * D + 100)}
    G_cache = {}
    def G(s, deg):
        key = (s, deg)
        if key in G_cache:
            return G_cache[key]
        tot = Fr(0)
        c1 = 1 - eps; c2 = 2 * eps
        for j in range(s + 1):
            tot += Fr(math.comb(s, j)) * (c1 ** j) * (c2 ** (s - j)) * Fr(fac[j], fac[k - 1 + j + deg])
        G_cache[key] = tot
        return tot
    splits = {gamma: split_a(list(gamma)) for gamma in parts}
    one_eps = 1 + eps
    I = [[Fr(0)] * n for _ in range(n)]
    J1 = [[Fr(0)] * n for _ in range(n)]
    for ia, (r1, alpha) in enumerate(basis):
        for ib, (r2, beta) in enumerate(basis):
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            rr = r1 + r2
            I[ia][ib] = (one_eps ** (k + deg + rr)) * Fr(fac[rr]) * H_exact(list(gamma), k, H_cache) / Fr(fac[k + rr + deg])
            tot = Fr(0)
            for ca, Sa, ga in splits[alpha]:
                Ba = Fr(fac[r1] * fac[Sa], fac[r1 + Sa + 1])
                for cb, Sb, gb in splits[beta]:
                    Bb = Fr(fac[r2] * fac[Sb], fac[r2 + Sb + 1])
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    dmu = sum(mu)
                    s = rr + 2 + Sa + Sb
                    tot += Fr(ca * cb) * Ba * Bb * ((1 - eps) ** (k - 1 + dmu)) * H_exact(list(mu), k - 1, H_cache) * G(s, dmu)
            J1[ia][ib] = tot
    out = f'frac_cache_{k}_{D}_e0.pkl'
    with open(out, 'wb') as f:
        pickle.dump((I, J1), f)
    print(f"saved {out} ({(time.time()-t0):.0f}s); I[0][0] = {I[0][0]}", flush=True)

if __name__ == '__main__':
    main()
