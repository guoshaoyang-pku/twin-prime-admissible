#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""routeB2.py — 路线 B 重构版: 父进程预计算 jtval 表 (fork 共享) + 主池纯查表
阶段:
  1. 父进程: H_cache, splits, marP/marM 结构 (含系数)
  2. 键枚举: P×M 与 M×M 的 (e1,e2,B,B2,B3,mu) 结构对 (region 恒为 0, k≥13)
  3. 并行填充 jtval (S 进程, 局部 JT0/H 缓存, 合并为一张大表)
  4. 主池: 每个 (i,j) 矩阵元素 = Σ_{t,t'} c·c'·jtval(查表)
用法: python3 routeB2.py k DP DM en ed [S]
"""
import sys, time, math, pickle
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
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    dp = {(): mpq(1)}
    for v in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx in range(len(state)):
                if idx > 0 and state[idx - 1] == state[idx]:
                    continue
                mult = state.count(state[idx])
                ns = list(state); ns[idx] += v; ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, mpq(0)) + cnt * mult
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, mpq(0)) + cnt
        dp = ndp
    val = mpq(0)
    for state, cnt in dp.items():
        if len(state) <= coords:
            f = math.factorial(coords) // math.factorial(coords - len(state))
            val += cnt * math.prod(math.factorial(s) for s in state) * f
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

def K_mpq(k, rho, a, gamma, Hc, Tc):
    tot = mpq(0)
    def rec(l, B, J, coef):
        nonlocal tot
        if l == len(gamma):
            dJ = sum(J)
            C = k - 2 + dJ
            Hval = mpq(1) if len(J) == 0 else H_exact(J, k - 1, Hc)
            tot += coef * Hval / mpq(math.factorial(k - 2 + dJ)) * T_exact_mpq(k, rho, a, B, C, Tc)
            return
        g = gamma[l]
        rec(l + 1, B + g, J, coef * k)
        for j in range(1, g + 1):
            rec(l + 1, B + (g - j), J + [j], coef * math.comb(g, j))
    rec(0, 0, [], mpq(1))
    return tot * k

def K2q_mpq(k, rho, a, gamma, Hc, Tc):
    tot = mpq(0)
    def rec(l, B, J, coef):
        nonlocal tot
        if l == len(gamma):
            dJ = sum(J)
            C = k - 2 + dJ
            Hval = mpq(1) if len(J) == 0 else H_exact(J, k - 1, Hc)
            tot += coef * Hval / mpq(math.factorial(k - 2 + dJ)) * T2_exact_mpq(k, rho, a, B, C, Tc)
            return
        g = gamma[l]
        rec(l + 1, B + g, J, coef * k)
        for j in range(1, g + 1):
            rec(l + 1, B + (g - j), J + [j], coef * math.comb(g, j))
    rec(0, 0, [], mpq(1))
    return tot * k

def T_exact_mpq(k, rho, a, B, C, cache):
    key = (k, int(rho.numerator), int(rho.denominator), a, B, C)
    if key in cache:
        return cache[key]
    one = mpq(1)
    km1 = k - 1
    mstar = min(mpq(1, k), rho / km1)
    rho1 = one - rho
    tot = mpq(0)
    if rho1 > 0:
        m1 = mstar if mstar < rho1 else rho1
        for q in range(a + 1):
            cq = mpq(math.comb(a, q)) * ((-1) ** q) / mpq((C + 1 + q) * (C + 2 + q))
            for r in range(a - q + 1):
                Lr = mpq(math.comb(a - q, r)) * ((-k) ** r)
                for p in range(C + 2 + q + 1):
                    Ap = mpq(math.comb(C + 2 + q, p)) * (rho ** (C + 2 + q - p)) * ((-km1) ** p)
                    pw = B + r + p
                    tot += cq * Lr * Ap * (m1 ** (pw + 1)) / mpq(pw + 1)
        if mstar > rho1:
            beta = mpq(math.factorial(a) * math.factorial(C), math.factorial(a + C + 1))
            def poly_int(c0, c1, E):
                s = mpq(0)
                for r in range(E + 1):
                    Lr = mpq(math.comb(E, r)) * ((-k) ** r)
                    for (c, mpow) in ((c0, B + r), (c1, B + r + 1)):
                        s += mpq(c) * Lr * (mstar ** (mpow + 1) - rho1 ** (mpow + 1)) / mpq(mpow + 1)
                return s
            tot += beta * (poly_int(-rho1, 1, a + C + 1)
                           + mpq(a + 1, a + C + 2) * poly_int(1, 0, a + C + 2))
    cache[key] = tot
    return tot

def T2_exact_mpq(k, rho, a, B, C, cache):
    key = ('sq', k, int(rho.numerator), int(rho.denominator), a, B, C)
    if key in cache:
        return cache[key]
    one = mpq(1)
    km1 = k - 1
    mstar = min(mpq(1, k), rho / km1)
    rho1 = one - rho
    tot = mpq(0)
    if rho1 > 0:
        m1 = mstar if mstar < rho1 else rho1
        for q in range(a + 1):
            cq = mpq(math.comb(a, q)) * ((-1) ** q)
            cq *= (mpq(1, C + 1 + q) - mpq(2, C + 2 + q) + mpq(1, C + 3 + q))
            for r in range(a - q + 1):
                Lr = mpq(math.comb(a - q, r)) * ((-k) ** r)
                for p in range(C + 3 + q + 1):
                    Ap = mpq(math.comb(C + 3 + q, p)) * (rho ** (C + 3 + q - p)) * ((-km1) ** p)
                    pw = B + r + p
                    tot += cq * Lr * Ap * (m1 ** (pw + 1)) / mpq(pw + 1)
        if mstar > rho1:
            beta = mpq(math.factorial(a) * math.factorial(C), math.factorial(a + C + 1))
            def poly_int(c0, c1, c2, E):
                s = mpq(0)
                for r in range(E + 1):
                    Lr = mpq(math.comb(E, r)) * ((-k) ** r)
                    for (c, mpow) in ((c0, B + r), (c1, B + r + 1), (c2, B + r + 2)):
                        s += mpq(c) * Lr * (mstar ** (mpow + 1) - rho1 ** (mpow + 1)) / mpq(mpow + 1)
                return s
            tot += beta * (poly_int(rho1 ** 2, -2 * rho1, 1, a + C + 1)
                           + mpq(2 * (a + 1), a + C + 2) * poly_int(-rho1, 1, 0, a + C + 2)
                           + mpq((a + 2) * (a + 1), (a + C + 2) * (a + C + 3)) * poly_int(1, 0, 0, a + C + 3))
    cache[key] = tot
    return tot

# ---- jtval 填充 (子进程) ----
_G2 = {}

def _init_jt0(k, eps, maxE, Bmax, blocks):
    _G2.update(k=k, eps=eps, maxE=maxE, Bmax=Bmax, blocks=blocks)

def _fill_jt0(_unused):
    k, eps = _G2['k'], _G2['eps']
    maxE, Bmax, blocks = _G2['maxE'], _G2['Bmax'], _G2['blocks']
    cJT = mpq(1) - eps
    cpow = [mpq(1)]
    for _ in range(maxE + 1):
        cpow.append(cpow[-1] * cJT)
    mstarJT = cJT / (k - 1)
    mspow = [mpq(1)]
    for _ in range(maxE + 1):
        mspow.append(mspow[-1] * mstarJT)
    out = {}
    for (a, B2, C) in blocks:
        # 预展开 s-loop 的系数 (hoist 出 B-loop)
        terms = []
        for s in range(B2 + 1):
            cs = mpq(math.comb(B2, s)) * mpq(math.factorial(a + s) * math.factorial(C),
                                             math.factorial(a + s + C + 1))
            E = a + s + C + 1
            Lrs = [mpq(math.comb(E, r)) * cpow[E - r] * ((-(k - 1)) ** r) for r in range(E + 1)]
            terms.append((cs, B2 - s, Lrs))
        for B in range(Bmax + 1):
            tot = mpq(0)
            for (cs, off, Lrs) in terms:
                Bp = B + off
                for (r, Lr) in enumerate(Lrs):
                    pw = Bp + r
                    tot += cs * Lr * mspow[pw + 1] / mpq(pw + 1)
            out[(a, B, B2, C)] = tot
    return out

def _init_fill(k, eps, H_cache, maxE, JT0tab=None):
    if JT0tab is not None:
        _G2.update(k=k, eps=eps, H_cache=H_cache, maxE=maxE, JT0tab=JT0tab)
    else:
        _G2.update(k=k, eps=eps, H_cache=H_cache, maxE=maxE)

def _build_wmaps(key_list, k, H_cache):
    """预计算每个 distinct mu 的 (Badd, dJ) -> 聚合权重 (主进程, fork 共享只读).
    关键: Badd + dJ = sum(mu) 恒定, 故 |wmap| <= sum(mu)+1 <= 15, 大幅压缩 JT0 查找."""
    mu_set = sorted({mu for (_, _, _, _, _, mu) in key_list})
    wmaps = {}
    for mu in mu_set:
        wmap = {}
        def rec(l, Badd, J, coef):
            if l == len(mu):
                dJ = sum(J)
                Hval = mpq(1) if dJ == 0 else H_exact(J, k - 2, H_cache)
                w = coef * Hval / mpq(math.factorial(k - 3 + dJ))
                key2 = (Badd, dJ)
                wmap[key2] = wmap.get(key2, mpq(0)) + w
                return
            mm = mu[l]
            rec(l + 1, Badd + mm, J, coef * (k - 1))
            for jj in range(1, mm + 1):
                rec(l + 1, Badd + (mm - jj), J + [jj], coef * math.comb(mm, jj))
        rec(0, 0, [], mpq(1))
        wmaps[mu] = wmap
    return wmaps

def _fill_keys(key_list):
    k, eps = _G2['k'], _G2['eps']
    H_cache, maxE = _G2['H_cache'], _G2['maxE']
    JT0tab = _G2.get('JT0tab')
    WMAP = _G2.get('WMAP')
    twoeps_pow = [mpq(1)]
    for _ in range(maxE + 1):
        twoeps_pow.append(twoeps_pow[-1] * (mpq(2) * eps))
    def JT0(a, B, B2, C):
        if JT0tab is not None:
            return JT0tab[(a, B, B2, C)]
        raise KeyError('no JT0tab')
    out = {}
    for (e1, e2, B, B2, B3, mu) in key_list:
        expanded = [(mpq(math.comb(B3, p3)) * twoeps_pow[B3 - p3] * ((-2) ** p3), B + p3)
                    for p3 in range(B3 + 1)]
        wmap = WMAP[mu]
        tot = mpq(0)
        for q in range(e2 + 1):
            cq = mpq(math.comb(e2, q)) * twoeps_pow[e2 - q] * mpq(k - 1)
            for (c3, Bp) in expanded:
                for (Badd, dJ), w in wmap.items():
                    tot += cq * c3 * w * JT0(e1 + q, Bp + Badd, B2, k - 3 + dJ)
        out[(e1, e2, B, B2, B3, mu)] = tot
    return out

def _init_build(marP, marM, jt_cache, basisP, basisM, k, DP, DM, eps, H_cache, splits, fac, rho, one_eps):
    _G2.update(marP=marP, marM=marM, jt_cache=jt_cache, basisP=basisP, basisM=basisM,
               k=k, DP=DP, DM=DM, eps=eps, H_cache=H_cache, splits=splits, fac=fac,
               rho=rho, one_eps=one_eps)

def _build_rows(idx_list):
    g = _G2
    k, DP, DM, eps = g['k'], g['DP'], g['DM'], g['eps']
    basisP, basisM = g['basisP'], g['basisM']
    marP, marM = g['marP'], g['marM']
    jt_cache, H_cache, splits, fac = g['jt_cache'], g['H_cache'], g['splits'], g['fac']
    rho, one_eps = g['rho'], g['one_eps']
    nP, nM = len(basisP), len(basisM)
    n = nP + nM
    Tc = {}
    def Ival_PP(r1, ga, r2, gb):
        gm = multiset_key(tuple(sorted(ga + gb)))
        deg = sum(gm); rr = r1 + r2
        return (one_eps ** (k + deg + rr)) * mpq(fac[rr]) * H_exact(list(gm), k, H_cache) / mpq(fac[k + rr + deg])
    def Ival_PM(r, ga, a, gb):
        gm = tuple(sorted(ga + gb)); deg = sum(gm)
        return (one_eps ** (k + deg + a + r + 1)) * K_mpq(k, rho, a + r, gm, H_cache, Tc)
    def Ival_MM(a1, ga, a2, gb):
        gm = tuple(sorted(ga + gb)); deg = sum(gm)
        return (one_eps ** (k + deg + a1 + a2 + 2)) * K2q_mpq(k, rho, a1 + a2, gm, H_cache, Tc)
    g_cache = {}
    Irows = {}; Jrows = {}
    for idx in idx_list:
        if idx < nP:
            (r1, ga), mar1 = basisP[idx], marP[idx]
        else:
            (a1, ga), mar1 = basisM[idx - nP], marM[idx - nP]
        Irow = [mpq(0)] * n
        Jrow = [mpq(0)] * n
        for jdx in range(n):
            if jdx < nP:
                (r2, gb), mar2 = basisP[jdx], marP[jdx]
            else:
                (a2, gb), mar2 = basisM[jdx - nP], marM[jdx - nP]
            if idx < nP and jdx < nP:
                Irow[jdx] = Ival_PP(r1, ga, r2, gb)
            elif idx < nP:
                Irow[jdx] = Ival_PM(r1, ga, a2, gb)
            elif jdx < nP:
                Irow[jdx] = Ival_PM(r2, gb, a1, ga)
            else:
                Irow[jdx] = Ival_MM(a1, ga, a2, gb)
            if idx < nP and jdx < nP:
                gm = multiset_key(tuple(sorted(ga + gb)))
                degm = sum(gm)
                rr = r1 + r2
                jtot = mpq(0)
                for ca, Sa, ga1 in splits[ga]:
                    Ba = mpq(fac[r1] * fac[Sa], fac[r1 + Sa + 1])
                    for cb, Sb, gb1 in splits[gb]:
                        Bb = mpq(fac[r2] * fac[Sb], fac[r2 + Sb + 1])
                        mu = multiset_key(tuple(sorted(ga1 + gb1)))
                        dmu = sum(mu)
                        s = rr + 2 + Sa + Sb
                        G = g_cache.get((s, dmu))
                        if G is None:
                            G = mpq(0)
                            for jj in range(s + 1):
                                G += mpq(math.comb(s, jj)) * ((mpq(1) - eps) ** jj) * ((mpq(2) * eps) ** (s - jj)) * mpq(fac[jj], fac[k - 1 + jj + dmu])
                            g_cache[(s, dmu)] = G
                        jtot += mpq(ca * cb) * Ba * Bb * ((mpq(1) - eps) ** (k - 1 + dmu)) * H_exact(list(mu), k - 1, H_cache) * G
            else:
                jtot = mpq(0)
                for (c1, e1a, e2a, Ba, B2a, mua, _, B3a) in mar1:
                    for (c2, e1b, e2b, Bb, B2b, mub, _, B3b) in mar2:
                        mu = multiset_key(tuple(sorted(mua + mub)))
                        key = (e1a + e1b, e2a + e2b, Ba + Bb, B2a + B2b, B3a + B3b, mu)
                        v = jt_cache.get(key)
                        if v is not None:
                            jtot += c1 * c2 * v
                        else:
                            raise KeyError(f"missing jtval key {key}")
            Jrow[jdx] = jtot
        Irows[idx] = Irow
        Jrows[idx] = Jrow
    return Irows, Jrows

def merge_terms(tl):
    d = {}
    for t in tl:
        key = t[1:]
        d[key] = d.get(key, mpq(0)) + t[0]
    return [(v,) + kk for kk, v in d.items()]

def build_marginals(k, DP, DM, eps, basisP, basisM, splits, fac):
    marP = []
    for (r, gamma) in basisP:
        tl = []
        for ca, Sa, ga in splits[gamma]:
            Ba = mpq(fac[r] * fac[Sa], fac[r + Sa + 1])
            tl.append((mpq(ca) * Ba, 0, r + Sa + 1, 0, 0, ga, 0, 0))
        marP.append(merge_terms(tl))
    mstar = (mpq(1) - eps) / (k - 1)
    skipB2 = (mpq(2) * eps >= mstar)
    marM = []
    for (a, gamma) in basisM:
        tl = []
        for ca, S1, garest in splits[gamma]:
            cbase = mpq(ca)
            for j in range(a + 1):
                cj = mpq(math.comb(a, j)) * ((-1) ** j) / mpq(S1 + j + 1)
                tl.append((cbase * cj, 1, a - j, S1 + j + 1, 0, garest, 0, 0))
            for j in range(a + 1):
                cj = mpq(math.comb(a, j)) * ((-1) ** j)
                for l in range(S1 + 1):
                    cl = mpq(math.comb(S1, l))
                    den = mpq((j + l + 1) * (j + l + 2))
                    for p in range(a - j + 1):
                        cp = mpq(math.comb(a - j, p))
                        coef = cbase * cj * cl * cp / den
                        tl.append((coef, j + l + 2, 0, S1 - l, p, garest, 0 if skipB2 else 1, a - j - p))
            if not skipB2:
                for l in range(S1 + 1):
                    cl = mpq(math.comb(S1, l)) * ((-1) ** l)
                    for E, cE, has_d in ((a + l + 1, mpq(1, a + l + 1), True), (a + l + 2, mpq(1, a + l + 2), False)):
                        for p in range(E + 1):
                            base2 = cbase * cl * cE * mpq(math.comb(E, p))
                            if has_d:
                                tl.append((base2, 0, S1 - l, 1, p, garest, 2, E - p))
                                tl.append((-base2 * mpq(2) * eps, 0, S1 - l, 0, p, garest, 2, E - p))
                            else:
                                tl.append((base2, 0, S1 - l, 0, p, garest, 2, E - p))
        marM.append(merge_terms(tl))
    return marP, marM

def main():
    t0 = time.time()
    k = int(sys.argv[1]); DP = int(sys.argv[2]); DM = int(sys.argv[3])
    en = int(sys.argv[4]); ed = int(sys.argv[5])
    S = int(sys.argv[6]) if len(sys.argv) > 6 else 24
    eps = mpq(en, ed)
    partsP = gen_even_partitions(DP)
    partsM = gen_even_partitions(DM)
    basisP = []
    for gamma in partsP:
        dg = sum(gamma)
        for r in range(0, DP - dg + 1):
            basisP.append((r, gamma))
    basisM = []
    for gamma in partsM:
        dg = sum(gamma)
        for a in range(0, DM - dg + 1):
            basisM.append((a, gamma))
    nP, nM = len(basisP), len(basisM)
    n = nP + nM
    print(f"routeB2 k={k} DP={DP} DM={DM} eps={en}/{ed} nP={nP} nM={nM} n={n} S={S}", flush=True)
    t1 = time.time()
    H_cache = {}
    allparts = sorted(set(partsP + partsM), key=lambda p: (sum(p), p))
    for coords in (k, k - 1, k - 2):
        for gamma in allparts:
            H_exact(list(gamma), coords, H_cache)
        for gamma in allparts:
            for delta in allparts:
                H_exact(list(sorted(gamma + delta)), coords, H_cache)
    print(f"H cache ({time.time()-t1:.0f}s, {len(H_cache)} entries)", flush=True)
    fac = {m2: math.factorial(m2) for m2 in range(0, 3 * DP + 3 * DM + 2 * k + 100)}
    splits = {gamma: split_a(list(gamma)) for gamma in set(partsP + partsM)}
    t2 = time.time()
    marP, marM = build_marginals(k, DP, DM, eps, basisP, basisM, splits, fac)
    print(f"marginals built ({time.time()-t2:.0f}s); |marM| sum = {sum(len(m) for m in marM)}", flush=True)
    # 键枚举 (结构去重)
    Pstructs = set()
    for m in marP:
        for (_, e1, e2, B, B2, mu, _, B3) in m:
            Pstructs.add((e1, e2, B, B2, mu, B3))
    Mstructs = set()
    for m in marM:
        for (_, e1, e2, B, B2, mu, _, B3) in m:
            Mstructs.add((e1, e2, B, B2, mu, B3))
    print(f"distinct P-structs: {len(Pstructs)}, M-structs: {len(Mstructs)}", flush=True)
    keys = set()
    for (e1p, e2p, Bp, B2p, mup, B3p) in Pstructs:
        for (e1m, e2m, Bm, B2m, mum, B3m) in Mstructs:
            mu = multiset_key(tuple(sorted(mup + mum)))
            keys.add((e1p + e1m, e2p + e2m, Bp + Bm, B2p + B2m, B3p + B3m, mu))
    Mlist = list(Mstructs)
    for i in range(len(Mlist)):
        for j in range(i, len(Mlist)):
            (e1a, e2a, Ba, B2a, mua, B3a) = Mlist[i]
            (e1b, e2b, Bb, B2b, mub, B3b) = Mlist[j]
            mu = multiset_key(tuple(sorted(mua + mub)))
            keys.add((e1a + e1b, e2a + e2b, Ba + Bb, B2a + B2b, B3a + B3b, mu))
    key_list = sorted(keys)
    print(f"total distinct keys: {len(key_list)}", flush=True)
    # JT0 表预计算 (分批 + 断点续跑, fork 共享)
    maxE = 3 * DP + 3 * DM + 2 * k + 300
    Amax = max(e1 for (e1, _, _, _, _, _) in key_list) + max(e2 for (_, e2, _, _, _, _) in key_list) + 1
    Bmax = max(B for (_, _, B, _, _, _) in key_list) + max(B3 for (_, _, _, _, B3, _) in key_list) + DP + DM + 5
    B2max = max(B2 for (_, _, _, B2, _, _) in key_list)
    Cmax = k - 3 + DP + DM + 5
    blocks = [(a, B2, C) for a in range(Amax + 1) for B2 in range(B2max + 1) for C in range(Cmax + 1)]
    print(f"JT0 blocks: {len(blocks)} (Amax={Amax}, Bmax={Bmax}, B2max={B2max}, Cmax={Cmax})", flush=True)
    JT0tab = {}
    part_file = f'jt0_tab_{k}_{DP}_{DM}.pkl'
    import os as _os
    if _os.path.exists(part_file):
        with open(part_file, 'rb') as f:
            JT0tab.update(pickle.load(f))
        print(f"loaded existing part {part_file} ({len(JT0tab)} entries so far)", flush=True)
    done_keys = set(JT0tab.keys())
    todo = [b for b in blocks if (b[0], 0, b[1], b[2]) not in done_keys]
    # 检测部分完成: 某 (a,B2,C) 的部分 B 已算过则整块重算 (简单起见跳过)
    todo = [b for b in blocks if all((b[0], B, b[1], b[2]) not in done_keys for B in range(Bmax + 1))]
    print(f"todo blocks: {len(todo)}", flush=True)
    BATCH = 2048
    nb = 0
    for bs in range(0, len(todo), BATCH):
        batch = todo[bs:bs + BATCH]
        blk_chunks = [batch[i::S] for i in range(S)]
        pool0 = mp.Pool(S, initializer=_init_jt0, initargs=(k, eps, maxE, Bmax, batch))
        t2b = time.time()
        for out in pool0.imap_unordered(_fill_jt0, blk_chunks):
            JT0tab.update(out)
        pool0.close(); pool0.join()
        nb += 1
        with open(part_file, 'wb') as f:
            pickle.dump(JT0tab, f)
        print(f"JT0 batch {nb} saved ({len(JT0tab)} entries, {time.time()-t2b:.0f}s)", flush=True)
    print(f"JT0 table complete: {len(JT0tab)} entries", flush=True)
    # 并行填充 jtval (JT0tab 经 fork 全局共享, 不经 initargs)
    t_w = time.time()
    _G2['WMAP'] = _build_wmaps(key_list, k, H_cache)
    print(f"WMAP built ({time.time()-t_w:.0f}s, {len(_G2['WMAP'])} mu)", flush=True)
    chunks = [key_list[i::S] for i in range(S)]
    _G2['JT0tab'] = JT0tab
    pool = mp.Pool(S, initializer=_init_fill, initargs=(k, eps, H_cache, maxE))
    t3 = time.time()
    jt_cache = {}
    done = 0
    for out in pool.imap_unordered(_fill_keys, chunks):
        jt_cache.update(out)
        done += 1
        print(f"  fill chunk {done}/{S} ({time.time()-t3:.0f}s, table {len(jt_cache)})", flush=True)
    pool.close(); pool.join()
    print(f"jtval table filled ({time.time()-t3:.0f}s, {len(jt_cache)} entries)", flush=True)
    # 主池 (fork 共享 jt_cache)
    rho = (mpq(1) - eps) / (mpq(1) + eps)
    one_eps = mpq(1) + eps
    pool2 = mp.Pool(S, initializer=_init_build,
                    initargs=(marP, marM, jt_cache, basisP, basisM, k, DP, DM, eps, H_cache, splits, fac, rho, one_eps))
    t4 = time.time()
    I = [[None] * n for _ in range(n)]
    J = [[None] * n for _ in range(n)]
    blocks = [list(range(i, n, S)) for i in range(S)]
    done = 0
    for Irows, Jrows in pool2.imap_unordered(_build_rows, blocks):
        for i, row in Irows.items():
            I[i] = row
        for i, row in Jrows.items():
            J[i] = row
        done += 1
        print(f"  block {done}/{S} merged ({time.time()-t4:.0f}s)", flush=True)
    pool2.close(); pool2.join()
    print(f"rows built ({time.time()-t4:.0f}s)", flush=True)
    fn = f'frac_cacheB_{k}_{DP}_{DM}_e{en}_{ed}.pkl'
    with open(fn, 'wb') as f:
        pickle.dump((I, J), f)
    print(f"saved {fn} ({time.time()-t0:.0f}s total)", flush=True)

if __name__ == '__main__':
    main()
