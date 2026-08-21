#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""mixed_strict.py — 严格有理数 λ_max 判定 (mixed 基 + LDL^T 惯性 + 二分)
基: {(1-P1)^r p_γ : r + deg(γ) ≤ D, γ 偶数划分} (等价论文对称单项式基子空间)
判定: λ_max(J1, I) > mid ⟺ J1 - mid·I 有正特征值 ⟺ ldl_sign 有正枢轴
用法: python3 mixed_strict.py k D eps_num eps_den [iters] [lo hi 预热]
"""
import sys, time, math, pickle
from fractions import Fraction as Fr
sys.path.insert(0, '.')
sys.path.insert(0, '..')
import importlib.util
spec = importlib.util.spec_from_file_location("mps", "../mk_probe_strict.py")
mps = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mps)
ldl_sign = mps.ldl_sign

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
    en = int(sys.argv[3]); ed = int(sys.argv[4])
    iters = int(sys.argv[5]) if len(sys.argv) > 5 else 30
    eps = Fr(en, ed)
    # 尝试从 pkl 加载 (I, J1) 缓存
    cfn = f'frac_cache_{k}_{D}.pkl'
    import os
    if os.path.exists(cfn):
        with open(cfn, 'rb') as f:
            I, J1 = pickle.load(f)
        print(f"loaded matrices from {cfn}", flush=True)
    else:
        parts = gen_even_partitions(D)
        basis = []
        for gamma in parts:
            for r in range(0, D - sum(gamma) + 1):
                basis.append((r, gamma))
        n = len(basis)
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
        with open(cfn, 'wb') as f:
            pickle.dump((I, J1), f)
        print(f"built & saved {cfn}", flush=True)
    n = len(I)
    print(f"k={k} eps={eps} D={D} n={n}", flush=True)
    # 预热区间 (float 特征值, 用 legendre 已失败——用 0 到 4/k? 或 float 粗略)
    lo = Fr(0)
    hi = Fr(4, k)  # 上界 λ ≤ 4/k (M ≤ 4 的解析界: M = k·λ ≤ 4 → λ ≤ 4/k)
    # float 预热: 用 ldl 判定 lo/hi 区间先粗调——直接用二分
    for it in range(iters):
        mid = (lo + hi) / 2
        t1 = time.time()
        Am = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
        pv = ldl_sign(Am)
        if pv is None:
            lo = hi = mid
            print(f"  iter {it}: zero-pivot at {float(mid):.9f}", flush=True)
            break
        if any(pv):
            lo = mid
        else:
            hi = mid
        print(f"  iter {it}: lambda in ({float(lo):.9f}, {float(hi):.9f}) ({time.time()-t1:.0f}s)", flush=True)
    print(f"RESULT k={k} eps={eps} D={D}: lambda_max in ({float(lo):.12f}, {float(hi):.12f})  "
          f"M in ({float(k*lo):.8f}, {float(k*hi):.8f})  (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
