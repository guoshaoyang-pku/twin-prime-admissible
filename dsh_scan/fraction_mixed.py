#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fraction_mixed.py — 幂和混合基 Fraction 精确 Gram + mpmath 高精度广义特征值
基: {(1-P1)^r · p_γ : r + deg(γ) ≤ D, γ 偶数划分}  (等价论文对称单项式基)
I[(r1,α),(r2,β)] = (1+eps)^{k+deg+r1+r2}·(r1+r2)!·H(α∪β;k)/(k+r1+r2+deg)!
J1 同 floatbuild 公式 (s = r1+r2+2+Sa+Sb)
特征值: mpmath 120 位 Lanczos on I^{-1}J (广义特征值 → 标准特征值)
用法: python3 fraction_mixed.py k D [eps_num eps_den] [mp_digits] [lanczos_steps]
"""
import sys, time, math
from fractions import Fraction as Fr
sys.path.insert(0, '.')

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
    """H(parts; coords) 精确有理数 (槽位 DP)"""
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
    """split_a: [(组合数, S=分给 t1 的和, 剩余元组)]"""
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
    if len(sys.argv) > 3:
        eps = Fr(int(sys.argv[3]), int(sys.argv[4]))
    digits = int(sys.argv[5]) if len(sys.argv) > 5 else 120
    nsteps = int(sys.argv[6]) if len(sys.argv) > 6 else 60
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    n = len(basis)
    print(f"fraction_mixed k={k} eps={eps} D={D} n={n}", flush=True)
    t1 = time.time()
    H_cache = {}
    for coords in (k, k - 1):
        for gamma in parts:
            H_exact(list(gamma), coords, H_cache)
        for gamma in parts:
            for delta in parts:
                H_exact(list(sorted(gamma + delta)), coords, H_cache)
    print(f"H cache ({time.time()-t1:.0f}s, {len(H_cache)} entries)", flush=True)
    fac = {m: math.factorial(m) for m in range(0, 2 * D + 100)}
    # G(s, deg) 精确: Σ_j C(s,j)(1-eps)^j (2eps)^{s-j} j!/(k-1+j+deg)!
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
    t2 = time.time()
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
    print(f"matrices built exactly ({time.time()-t2:.0f}s)", flush=True)
    import pickle
    with open(f'frac_cache_{k}_{D}.pkl', 'wb') as f:
        pickle.dump((I, J1), f)
    print("matrices saved to pkl", flush=True)
    # mpmath Lanczos
    import mpmath as mp
    mp.mp.dps = digits
    # 转 mpmath 矩阵 (一次, 缓存)
    def to_mp(M):
        return [[mp.mpf(x.numerator) / mp.mpf(x.denominator) for x in row] for row in M]
    print(f"converting to mpmath ({digits} digits)...", flush=True)
    tm1 = time.time()
    Im = to_mp(I)
    Jm = to_mp(J1)
    d = [mp.mpf(1) / mp.sqrt(Im[i][i]) for i in range(n)]
    Is = [[Im[i][j] * d[i] * d[j] for j in range(n)] for i in range(n)]
    Js = [[Jm[i][j] * d[i] * d[j] for j in range(n)] for i in range(n)]
    print(f"mpmath matrices ready ({time.time()-tm1:.0f}s); LU decomposition...", flush=True)
    A = mp.matrix(Is)
    t3 = time.time()
    P, L, U = mp.lu(A)
    print(f"LU done ({time.time()-t3:.0f}s)", flush=True)
    # 手动回代: 解 A x = b 即 L y = P b, U x = y
    def forward_sub(M, b):
        m = len(b); y = [mp.mpf(0)] * m
        for i in range(m):
            s = b[i]
            for j in range(i):
                s -= M[i, j] * y[j]
            y[i] = s / M[i, i]
        return y
    def back_sub(M, b):
        m = len(b); x = [mp.mpf(0)] * m
        for i in range(m - 1, -1, -1):
            s = b[i]
            for j in range(i + 1, m):
                s -= M[i, j] * x[j]
            x[i] = s / M[i, i]
        return x
    def applyInvJ(v):
        jv = [sum(Js[i][j] * v[j] for j in range(n)) for i in range(n)]
        pb = [jv[i] for i in range(n)]
        # 用 P 置换: P b (mpmath 的 P 是置换矩阵)
        pb2 = [mp.mpf(0)] * n
        for i in range(n):
            for j in range(n):
                if P[i, j] != 0:
                    pb2[i] = jv[j]
        y = forward_sub(L, pb2)
        return back_sub(U, y)
    def Idot(u, v):
        return sum(Is[i][j] * u[i] * v[j] for i in range(n) for j in range(n))
    v = [mp.mpf(1) for _ in range(n)]
    vnorm = mp.sqrt(Idot(v, v))
    v = [x / vnorm for x in v]
    lam = mp.mpf(0)
    for it in range(nsteps):
        w = applyInvJ(v)
        denom = Idot(v, v)
        num = sum(Js[i][j] * v[i] * v[j] for i in range(n) for j in range(n))
        lam = num / denom
        vnorm = mp.sqrt(Idot(w, w))
        if vnorm == 0:
            break
        v = [x / vnorm for x in w]
        if it % 10 == 0:
            print(f"  iter {it}: lambda = {mp.nstr(lam, 15)}", flush=True)
    M = mp.mpf(k) * lam
    print(f"RESULT k={k} eps={eps} D={D}: lambda_max = {mp.nstr(lam, 15)}  M = {mp.nstr(M, 15)}  (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
