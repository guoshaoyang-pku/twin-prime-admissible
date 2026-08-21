#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""frac_multi.py — 并行多 ε 精确矩阵构建 (gmpy2.mpq + multiprocessing)
基 (论文等价): {(1+ε-P1)^r · p_γ : r+deg(γ)≤D, γ 偶数划分}
一次构建, 同时输出多个 ε 的 (I, J1) (每股 ε 存 frac_cache_{k}_{D}_e{en}_{ed}.pkl)
用法: python3 frac_multi.py k D eps_num/eps_den [eps_num/eps_den ...] [S]
"""
import sys, time, math, pickle, os
import multiprocessing as mp
from gmpy2 import mpq

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
    """H(parts; coords) 精确有理数 (槽位 DP), 返回 mpq"""
    key = (multiset_key(parts), coords)
    v = cache.get(key)
    if v is not None:
        return v
    dp = {(): mpq(1)}
    for val in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx in range(len(state)):
                if idx > 0 and state[idx - 1] == state[idx]:
                    continue
                mult = state.count(state[idx])
                ns = list(state); ns[idx] += val; ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, mpq(0)) + cnt * mult
            ns = tuple(sorted(state + (val,)))
            ndp[ns] = ndp.get(ns, mpq(0)) + cnt
        dp = ndp
    tot = mpq(0)
    for state, cnt in dp.items():
        if len(state) <= coords:
            f = math.factorial(coords) // math.factorial(coords - len(state))
            tot += cnt * math.prod(math.factorial(s) for s in state) * f
    cache[key] = tot
    return tot

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

_GLOB = {}

def _init_worker(k, D, parts, basis, H_cache, splits, eps_list, fac):
    _GLOB.update(k=k, D=D, parts=parts, basis=basis, H_cache=H_cache,
                 splits=splits, eps_list=eps_list, fac=fac)

def _build_rows(ia_list):
    g = _GLOB
    k, D = g['k'], g['D']
    basis = g['basis']; H_cache = g['H_cache']; splits = g['splits']
    eps_list = g['eps_list']; fac = g['fac']
    m = len(eps_list)
    # 每股 ε 的 G 表: G[(e,s,dmu)] = Σ_j C(s,j)(1-ε)^j(2ε)^{s-j} j!/(k-1+j+dmu)!
    Gtab = []
    for e in range(m):
        eps = eps_list[e]
        c1 = mpq(1) - eps; c2 = 2 * eps
        gt = {}
        for s in range(0, 2 * D + 3):
            for dmu in range(0, 2 * D + 1):
                tot = mpq(0)
                for j in range(s + 1):
                    tot += mpq(math.comb(s, j)) * (c1 ** j) * (c2 ** (s - j)) * mpq(fac[j], fac[k - 1 + j + dmu])
                gt[(s, dmu)] = tot
        Gtab.append(gt)
    c1pow = []
    for e in range(m):
        c1 = mpq(1) - eps_list[e]
        pw = [mpq(1)]
        for _ in range(k + 3 * D + 5):
            pw.append(pw[-1] * c1)
        c1pow.append(pw)
    e1pow = []
    for e in range(m):
        e1 = mpq(1) + eps_list[e]
        pw = [mpq(1)]
        for _ in range(k + 2 * D + 5):
            pw.append(pw[-1] * e1)
        e1pow.append(pw)
    Irows = {}; Jrows = {}
    for ia in ia_list:
        r1, alpha = basis[ia]
        Irow = []; Jrow = []
        for ib, (r2, beta) in enumerate(basis):
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            rr = r1 + r2
            Hgk = H_exact(list(gamma), k, H_cache)
            coeffI = mpq(fac[rr]) * Hgk / mpq(fac[k + rr + deg])
            Ientry = [e1pow[e][k + deg + rr] * coeffI for e in range(m)]
            tots = [mpq(0)] * m
            for ca, Sa, ga in splits[alpha]:
                Ba = mpq(fac[r1] * fac[Sa], fac[r1 + Sa + 1])
                for cb, Sb, gb in splits[beta]:
                    Bb = mpq(fac[r2] * fac[Sb], fac[r2 + Sb + 1])
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    dmu = sum(mu)
                    s = rr + 2 + Sa + Sb
                    coef = mpq(ca * cb) * Ba * Bb * H_exact(list(mu), k - 1, H_cache)
                    for e in range(m):
                        tots[e] += coef * c1pow[e][k - 1 + dmu] * Gtab[e][(s, dmu)]
            Irow.append(Ientry); Jrow.append(tots)
        Irows[ia] = Irow; Jrows[ia] = Jrow
    return Irows, Jrows

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    eps_strs = []
    i = 3
    while i < len(sys.argv) and '/' in sys.argv[i]:
        eps_strs.append(sys.argv[i]); i += 1
    S = int(sys.argv[i]) if i < len(sys.argv) else 24
    eps_list = [mpq(int(a), int(b)) for a, b in (s.split('/') for s in eps_strs)]
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    n = len(basis)
    print(f"frac_multi k={k} D={D} n={n} eps={eps_strs} S={S}", flush=True)
    t1 = time.time()
    H_cache = {}
    for coords in (k, k - 1):
        for gamma in parts:
            H_exact(list(gamma), coords, H_cache)
        for gamma in parts:
            for delta in parts:
                H_exact(list(sorted(gamma + delta)), coords, H_cache)
    print(f"H cache ({time.time()-t1:.0f}s, {len(H_cache)} entries)", flush=True)
    fac = {m2: math.factorial(m2) for m2 in range(0, 3 * D + 2 * k + 100)}
    splits = {gamma: split_a(list(gamma)) for gamma in parts}
    # 按行分块
    blocks = [list(range(i, n, S)) for i in range(S)]
    pool = mp.Pool(S, initializer=_init_worker,
                   initargs=(k, D, parts, basis, H_cache, splits, eps_list, fac))
    t2 = time.time()
    m = len(eps_list)
    I = [[[None] * n for _ in range(n)] for _ in range(m)]
    J = [[[None] * n for _ in range(n)] for _ in range(m)]
    done = 0
    for Irows, Jrows in pool.imap_unordered(_build_rows, blocks):
        for ia, row in Irows.items():
            for ib, entry in enumerate(row):
                for e in range(m):
                    I[e][ia][ib] = entry[e]
        for ia, row in Jrows.items():
            for ib, entry in enumerate(row):
                for e in range(m):
                    J[e][ia][ib] = entry[e]
        done += 1
        print(f"  block {done}/{S} merged ({time.time()-t2:.0f}s)", flush=True)
    pool.close(); pool.join()
    print(f"rows built ({time.time()-t2:.0f}s)", flush=True)
    t3 = time.time()
    for e, s in enumerate(eps_strs):
        en, ed = s.split('/')
        fn = f'frac_cache_{k}_{D}_e{en}_{ed}.pkl'
        with open(fn, 'wb') as f:
            pickle.dump((I[e], J[e]), f)
        print(f"saved {fn} ({time.time()-t3:.0f}s)", flush=True)
    print(f"TOTAL {time.time()-t0:.0f}s", flush=True)

if __name__ == '__main__':
    main()
