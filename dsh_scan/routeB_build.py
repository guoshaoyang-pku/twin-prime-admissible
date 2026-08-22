#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""routeB_build.py — 路线 B: 多项式族 ∪ min-截断族 的精确 Gram 矩阵 (mpq, 并行)
基 (t-坐标, (1+ε)R_k):
  P: (r, γ):  b^P = (1+ε-P₁)^r · p_γ,            r+deg(γ) ≤ DP
  M: (a, γ):  b^M = (1+ε-P₁)^a · (1-ε-M₁)_+ · p_γ, a+deg(γ) ≤ DM
  M₁ = max_i P₁^{(i)} = P₁ - min_i t_i
积分公式: I 侧见 min_core (K, K2q); J1 侧见 min_j1 (JT) + 边际展开。
输出: frac_cacheB_{k}_{DP}_{DM}_e{en}_{ed}.pkl  (I, J1 完整矩阵, mpq)
用法: python3 routeB_build.py k DP DM en ed [S]
"""
import sys, time, math, pickle
import multiprocessing as mp
from gmpy2 import mpq
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

# ---- min_core 的 mpq 版本 ----
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

def JT_exact_mpq_region(kp, c, a, B, B2, C, cache, lo, hi):
    """JT 积分, m ∈ [lo, hi] (多项式展开支持任意区间)"""
    key = (kp, int(c.numerator), int(c.denominator), a, B, B2, C, int(lo.numerator), int(lo.denominator),
           int(hi.numerator), int(hi.denominator))
    if key in cache:
        return cache[key]
    tot = mpq(0)
    for s in range(B2 + 1):
        cs = mpq(math.comb(B2, s)) * mpq(math.factorial(a + s) * math.factorial(C),
                                         math.factorial(a + s + C + 1))
        E = a + s + C + 1
        Bp = B + B2 - s
        for r in range(E + 1):
            Lr = mpq(math.comb(E, r)) * (c ** (E - r)) * ((-kp) ** r)
            pw = Bp + r
            tot += cs * Lr * (hi ** (pw + 1) - lo ** (pw + 1)) / mpq(pw + 1)
    cache[key] = tot
    return tot

def JT_exact_mpq(kp, c, a, B, B2, C, cache):
    key = (kp, int(c.numerator), int(c.denominator), a, B, B2, C)
    if key in cache:
        return cache[key]
    tot = mpq(0)
    for s in range(B2 + 1):
        cs = mpq(math.comb(B2, s)) * mpq(math.factorial(a + s) * math.factorial(C),
                                         math.factorial(a + s + C + 1))
        E = a + s + C + 1
        Bp = B + B2 - s
        for r in range(E + 1):
            Lr = mpq(math.comb(E, r)) * (c ** (E - r)) * ((-kp) ** r)
            pw = Bp + r
            tot += cs * Lr * (mpq(c, kp) ** (pw + 1)) / mpq(pw + 1)
    cache[key] = tot
    return tot

_G = {}

def _init_worker(k, DP, DM, eps, partsP, partsM, basisP, basisM, H_cache, splits, fac, skipB2):
    _G.update(k=k, DP=DP, DM=DM, eps=eps, partsP=partsP, partsM=partsM,
              basisP=basisP, basisM=basisM, H_cache=H_cache, splits=splits, fac=fac,
              skipB2=skipB2)

def _build_rows(idx_list):
    g = _G
    k, DP, DM, eps = g['k'], g['DP'], g['DM'], g['eps']
    basisP, basisM = g['basisP'], g['basisM']
    H_cache, splits, fac = g['H_cache'], g['splits'], g['fac']
    nP, nM = len(basisP), len(basisM)
    n = nP + nM
    rho = (mpq(1) - eps) / (mpq(1) + eps)
    one_eps = mpq(1) + eps
    # I 侧缓存与 J1 侧缓存 (本 worker 私有)
    Tc = {}; Jc = {}; g_cache = {}
    def merge_terms(tl):
        d = {}
        for t in tl:
            key = t[1:]
            d[key] = d.get(key, mpq(0)) + t[0]
        return [(v,) + k for k, v in d.items()]
    # 边际项列表: P 元素 (region 0, B3=0)
    marP = []
    for (r, gamma) in basisP:
        tl = []
        for ca, Sa, ga in splits[gamma]:
            Ba = mpq(fac[r] * fac[Sa], fac[r + Sa + 1])
            tl.append((mpq(ca) * Ba, 0, r + Sa + 1, 0, 0, ga, 0, 0))
        marP.append(merge_terms(tl))
    # M 元素边际 (piece A + piece B [+ piece B2 若区域非空])
    # region 编码: 0=全区域, 1={m ≤ 2ε}, 2={m ≥ 2ε}
    # skipB2: (1-ε)/(k-1) ≤ 2ε 时 region 2 为空 (k≥13, ε=1/25 恒成立), 且 region 1 = 全域
    skipB2 = g['skipB2']
    marM = []
    for (a, gamma) in basisM:
        tl = []
        for ca, S1, garest in splits[gamma]:
            cbase = mpq(ca)
            # piece A: t1 ∈ [0, tmin], 被积 h1·(L1-t1)^a·t1^S1  (全区域)
            for j in range(a + 1):
                cj = mpq(math.comb(a, j)) * ((-1) ** j) / mpq(S1 + j + 1)
                tl.append((cbase * cj, 1, a - j, S1 + j + 1, 0, garest, 0, 0))
            # piece B: t1 ∈ [tmin, tmin+h1] (仅 m ≤ 2ε), 被积 (h1-x)·(L1-tmin-x)^a·(tmin+x)^S1
            # (L1-tmin)^{a-j} = Σ_p C(a-j,p) factor2^p (2ε-2m)^{a-j-p}  (B3 紧凑)
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
                # piece B2: t1 ∈ [tmin, L1] (仅 m ≥ 2ε), 被积 x^a·(d+x)·(L1-x)^S1, x=L1-t1, d=m-2ε
                # = Σ_l C(S1,l) L1^{S1-l} (-1)^l [ d·(L1-tmin)^{a+l+1}/(a+l+1) + (L1-tmin)^{a+l+2}/(a+l+2) ]
                # (L1-tmin)^E = Σ_p C(E,p) factor2^p (2ε-2m)^{E-p}
                for l in range(S1 + 1):
                    cl = mpq(math.comb(S1, l)) * ((-1) ** l)
                    for E, cE, has_d in ((a + l + 1, mpq(1, a + l + 1), True), (a + l + 2, mpq(1, a + l + 2), False)):
                        for p in range(E + 1):
                            base2 = cbase * cl * cE * mpq(math.comb(E, p))
                            if has_d:
                                # d·(...) = (m-2ε)·(...): B+1 与 B+0 两个子项
                                tl.append((base2, 0, S1 - l, 1, p, garest, 2, E - p))
                                tl.append((-base2 * mpq(2) * eps, 0, S1 - l, 0, p, garest, 2, E - p))
                            else:
                                tl.append((base2, 0, S1 - l, 0, p, garest, 2, E - p))
        marM.append(merge_terms(tl))
    # JT 闭包 (幂表加速)
    maxE = 3 * DP + 3 * DM + 2 * k + 300
    cJT = mpq(1) - eps
    cpow = [mpq(1)]
    for _ in range(maxE + 1):
        cpow.append(cpow[-1] * cJT)
    mstarJT = cJT / (k - 1)
    mspow = [mpq(1)]
    for _ in range(maxE + 1):
        mspow.append(mspow[-1] * mstarJT)
    def JT_reg(a, B, B2, C, lo, hi):
        if hi <= lo:
            return mpq(0)
        key = (a, B, B2, C, int(lo.numerator), int(lo.denominator), int(hi.numerator), int(hi.denominator))
        v = Jc.get(key)
        if v is not None:
            return v
        tot = mpq(0)
        for s in range(B2 + 1):
            cs = mpq(math.comb(B2, s)) * mpq(math.factorial(a + s) * math.factorial(C),
                                             math.factorial(a + s + C + 1))
            E = a + s + C + 1
            Bp = B + B2 - s
            for r in range(E + 1):
                Lr = mpq(math.comb(E, r)) * cpow[E - r] * ((-(k - 1)) ** r)
                pw = Bp + r
                tot += cs * Lr * (hi ** (pw + 1) - lo ** (pw + 1)) / mpq(pw + 1)
        Jc[key] = tot
        return tot
    def JT0(a, B, B2, C):
        # region 0: m ∈ [0, mstarJT] (mstarJT = (1-ε)/(k-1))
        key = (a, B, B2, C)
        v = Jc.get(key)
        if v is not None:
            return v
        tot = mpq(0)
        for s in range(B2 + 1):
            cs = mpq(math.comb(B2, s)) * mpq(math.factorial(a + s) * math.factorial(C),
                                             math.factorial(a + s + C + 1))
            E = a + s + C + 1
            Bp = B + B2 - s
            for r in range(E + 1):
                Lr = mpq(math.comb(E, r)) * cpow[E - r] * ((-(k - 1)) ** r)
                pw = Bp + r
                tot += cs * Lr * mspow[pw + 1] / mpq(pw + 1)
        Jc[key] = tot
        return tot
    # (2ε-2m)^{B3} = Σ_p C(B3,p)(2ε)^{B3-p}(-2)^p m^p 折叠进 B
    twoeps_pow = [mpq(1)]
    for _ in range(maxE + 1):
        twoeps_pow.append(twoeps_pow[-1] * (mpq(2) * eps))
    # mu 的最小展开分支预计算: [(coef, Badd, J)]
    branch_cache = {}
    def branches(mu):
        v = branch_cache.get(mu)
        if v is not None:
            return v
        out = []
        def rec(l, Badd, J, coef):
            if l == len(mu):
                out.append((coef, Badd, tuple(J)))
                return
            mm = mu[l]
            rec(l + 1, Badd + mm, J, coef * (k - 1))
            for jj in range(1, mm + 1):
                rec(l + 1, Badd + (mm - jj), J + [jj], coef * math.comb(mm, jj))
        rec(0, 0, [], mpq(1))
        branch_cache[mu] = out
        return out
    jt_cache = {}
    def jtval(e1, e2, B, B2, B3, mu, region):
        key = (e1, e2, B, B2, B3, mu, region)
        v = jt_cache.get(key)
        if v is not None:
            return v
        # B3 展开
        expanded = [(mpq(math.comb(B3, p3)) * twoeps_pow[B3 - p3] * ((-2) ** p3), B + p3)
                    for p3 in range(B3 + 1)]
        if k == 2:
            # t' 一维: 无 w 空间; p_mu(m) = m^{dmu}; (1-ε-S+t_min) = 1-ε (常数)
            dmu = sum(mu)
            c = mpq(1) - eps
            mstar = c
            if region == 1:
                lo, hi = mpq(0), min(mpq(2) * eps, mstar)
            elif region == 2:
                lo, hi = max(mpq(0), mpq(2) * eps), mstar
            else:
                lo, hi = mpq(0), mstar
            tot = mpq(0)
            if hi > lo:
                for q in range(e2 + 1):
                    cq = mpq(math.comb(e2, q)) * twoeps_pow[e2 - q]
                    # ∫_lo^hi m^{B+dmu}(c-m)^{e1+q} dm, c = 1-ε (多项式展开)
                    c = mpq(1) - eps
                    E = e1 + q
                    for (c3, Bp) in expanded:
                        for r in range(E + 1):
                            Lr = mpq(math.comb(E, r)) * (c ** (E - r)) * ((-1) ** r)
                            pw = Bp + dmu + r
                            tot += cq * c3 * (c ** B2) * Lr * (hi ** (pw + 1) - lo ** (pw + 1)) / mpq(pw + 1)
            jt_cache[key] = tot
            return tot
        tot = mpq(0)
        c = mpq(1) - eps
        mstar = c / (k - 1)
        if region == 1:
            lo, hi = mpq(0), min(mpq(2) * eps, mstar)
        elif region == 2:
            lo, hi = max(mpq(0), mpq(2) * eps), mstar
        else:
            lo, hi = mpq(0), mstar
        if hi <= lo:
            jt_cache[key] = mpq(0)
            return mpq(0)
        br = branches(mu)
        for q in range(e2 + 1):
            cq = mpq(math.comb(e2, q)) * twoeps_pow[e2 - q] * mpq(k - 1)
            for (c3, Bp) in expanded:
                for (cbr, Badd, J) in br:
                    dJ = sum(J)
                    Hval = mpq(1) if len(J) == 0 else H_exact(J, k - 2, H_cache)
                    hcoef = cq * c3 * cbr * Hval / mpq(math.factorial(k - 3 + dJ))
                    if region == 0:
                        tot += hcoef * JT0(e1 + q, Bp + Badd, B2, k - 3 + dJ)
                    else:
                        tot += hcoef * JT_reg(e1 + q, Bp + Badd, B2, k - 3 + dJ, lo, hi)
        jt_cache[key] = tot
        return tot
    # I 侧标量函数
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
            # J1: P×P 直通快速公式; 其余走 jtval 项配对
            if idx < nP and jdx < nP:
                # fraction_mixed 直通公式 (已验证)
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
                for (c1, e1a, e2a, Ba, B2a, mua, rga, B3a) in mar1:
                    for (c2, e1b, e2b, Bb, B2b, mub, rgb, B3b) in mar2:
                        if (rga == 1 and rgb == 2) or (rga == 2 and rgb == 1):
                            continue
                        region = rga if rga != 0 else rgb
                        mu = multiset_key(tuple(sorted(mua + mub)))
                        jtot += c1 * c2 * jtval(e1a + e1b, e2a + e2b, Ba + Bb, B2a + B2b, B3a + B3b, mu, region)
            Jrow[jdx] = jtot
        Irows[idx] = Irow
        Jrows[idx] = Jrow
    return Irows, Jrows

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
    print(f"routeB k={k} DP={DP} DM={DM} eps={en}/{ed} nP={nP} nM={nM} n={n} S={S}", flush=True)
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
    mstar = (mpq(1) - eps) / (k - 1)
    skipB2 = (mpq(2) * eps >= mstar)
    print(f"mstar={mstar} 2eps={mpq(2)*eps} skipB2={skipB2}", flush=True)
    pool = mp.Pool(S, initializer=_init_worker,
                   initargs=(k, DP, DM, eps, partsP, partsM, basisP, basisM, H_cache, splits, fac, skipB2))
    t2 = time.time()
    I = [[None] * n for _ in range(n)]
    J = [[None] * n for _ in range(n)]
    blocks = [list(range(i, n, S)) for i in range(S)]
    done = 0
    for Irows, Jrows in pool.imap_unordered(_build_rows, blocks):
        for i, row in Irows.items():
            I[i] = row
        for i, row in Jrows.items():
            J[i] = row
        done += 1
        print(f"  block {done}/{S} merged ({time.time()-t2:.0f}s)", flush=True)
    pool.close(); pool.join()
    print(f"rows built ({time.time()-t2:.0f}s)", flush=True)
    fn = f'frac_cacheB_{k}_{DP}_{DM}_e{en}_{ed}.pkl'
    with open(fn, 'wb') as f:
        pickle.dump((I, J), f)
    print(f"saved {fn} ({time.time()-t0:.0f}s total)", flush=True)

if __name__ == '__main__':
    main()
