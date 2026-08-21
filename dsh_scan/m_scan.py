#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""m_scan v4 — 论文原样 (对称单项式基), 无递归迭代展开 + 缓存 DP
W[i,γ] = (1-P1)^a m_α 的 γ 系数 (single_col_mul(1,·) 迭代)
G1[γ,δ] = ∫_{R_k} m_γ m_δ  (坐标配对 DP, 全局缓存)
G2[γ,δ] = ∫_{R_{k+1}} m_γ(t) m_δ(t') (共享 k-1 坐标, 全局缓存)
M1 = W G1 W^T,  M2 = k·W G2 W^T
用法: python3 m_scan.py k D
"""
import sys, time, math
from collections import Counter
from functools import lru_cache
import numpy as np

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def all_partitions(max_deg):
    res = {0: [()]}
    for d in range(1, max_deg + 1):
        lst = []
        def rec(rem, parts, minv):
            if rem == 0:
                lst.append(tuple(parts)); return
            for v in range(minv, rem + 1):
                rec(rem - v, parts + [v], v)
        rec(d, [], 1)
        res[d] = lst
    return res

def single_col_mul(r, beta):
    """m_(r) · m_β = {γ: c},  c = γ 中新 part 的重数 (手工验证: m_(1)m_(1)=m_(2)+2m_(1,1))"""
    res = {}
    b = list(beta)
    for v in set(b):
        g = list(b); g.remove(v); g.append(v + r)
        g = tuple(sorted(g, reverse=True))
        res[g] = res.get(g, 0) + g.count(v + r)
    g = tuple(sorted(b + [r], reverse=True))
    res[g] = res.get(g, 0) + g.count(r)
    return {k: v for k, v in res.items() if v != 0}

def iter_mul1(table, steps):
    """P1^k · (Σ_c c·m_μ) 的系数表"""
    for _ in range(steps):
        new = {}
        for mu, c in table.items():
            for nu, c2 in single_col_mul(1, mu).items():
                new[nu] = new.get(nu, 0.0) + c * c2
        table = new
    return table

def m_integral_Rk(m, k):
    L = sum(m.values())
    if L > k:
        return 0.0
    total = 0; dens = 1
    for v, cnt in m.items():
        total += v * cnt
        dens *= math.factorial(cnt)
    nterms = math.factorial(k) // (dens * math.factorial(k - L))
    return nterms * math.factorial(total) / math.factorial(k + total)

_G1_CACHE = {}
def G1pair(mA, mB, k):
    """∫_{R_k} m_A m_B = Σ_{(a,b) 指数对} (a+b)!/(k+|A|+|B|)!"""
    key = (tuple(sorted(mA.elements())), tuple(sorted(mB.elements())))
    if key in _G1_CACHE:
        return _G1_CACHE[key]
    A = list(key[0]); B = list(key[1])
    if len(A) > k or len(B) > k:
        _G1_CACHE[key] = 0.0
        return 0.0
    deg = sum(A) + sum(B)
    @lru_cache(maxsize=None)
    def dp(ia, ib, cl):
        if ia == len(A) and ib == len(B):
            return 1.0
        if cl == 0:
            return 0.0
        res = 0.0
        if ia < len(A) and ib < len(B):
            res += math.factorial(A[ia] + B[ib]) * dp(ia + 1, ib + 1, cl - 1)
        if ia < len(A):
            res += math.factorial(A[ia]) * dp(ia + 1, ib, cl - 1)
        if ib < len(B):
            res += math.factorial(B[ib]) * dp(ia, ib + 1, cl - 1)
        res += dp(ia, ib, cl - 1)
        return res
    v = dp(0, 0, k) / math.factorial(k + deg)
    dp.cache_clear()
    _G1_CACHE[key] = v
    return v

_G2_CACHE = {}
def M2pair(mA, mB, k):
    """∫_{R_{k+1}} m_A(t) m_B(t') dt dt' (共享 k-1 坐标)"""
    key = (tuple(sorted(mA.elements())), tuple(sorted(mB.elements())))
    if key in _G2_CACHE:
        return _G2_CACHE[key]
    A = list(key[0]); B = list(key[1])
    if len(A) > k or len(B) > k:
        _G2_CACHE[key] = 0.0
        return 0.0
    degA = sum(A); degB = sum(B)
    tot = 0.0
    for p in [0] + sorted(set(A)):
        for q in [0] + sorted(set(B)):
            remA = A.copy(); remB = B.copy()
            if p: remA.remove(p)
            if q: remB.remove(q)
            if len(remA) > k - 1 or len(remB) > k - 1:
                continue
            @lru_cache(maxsize=None)
            def dp2(ia, ib, cl):
                if ia == len(remA) and ib == len(remB):
                    return 1.0
                if cl == 0:
                    return 0.0
                res = 0.0
                if ia < len(remA) and ib < len(remB):
                    res += math.factorial(remA[ia] + remB[ib]) * dp2(ia + 1, ib + 1, cl - 1)
                if ia < len(remA):
                    res += math.factorial(remA[ia]) * dp2(ia + 1, ib, cl - 1)
                if ib < len(remB):
                    res += math.factorial(remB[ib]) * dp2(ia, ib + 1, cl - 1)
                res += dp2(ia, ib, cl - 1)
                return res
            w2 = dp2(0, 0, k - 1)
            dp2.cache_clear()
            tot += math.factorial(p) * math.factorial(q) * w2 / math.factorial(k + 1 + degA + degB)
    _G2_CACHE[key] = tot
    return tot

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    PART = all_partitions(D)
    parts = gen_even_partitions(D)
    basis = []
    for alpha in parts:
        for a in range(0, D - sum(alpha) + 1):
            if len(alpha) + a <= k:
                basis.append((a, alpha))
    n = len(basis)
    print(f"m_scan v4 k={k} D={D} n={n}", flush=True)
    # W 展开
    t1 = time.time()
    row_exps = []
    for (a, alpha) in basis:
        tmap = {}
        for kk in range(a + 1):
            w = math.comb(a, kk) * ((-1) ** kk)
            tbl = iter_mul1({alpha: 1.0}, kk)
            for mu, c in tbl.items():
                tmap[mu] = tmap.get(mu, 0.0) + w * c
        row_exps.append({mu: c for mu, c in tmap.items() if c != 0})
    all_idx = {}
    for e in row_exps:
        for mu in e:
            if mu not in all_idx:
                all_idx[mu] = len(all_idx)
    N = len(all_idx)
    keys = list(all_idx.keys())
    print(f"W expanded, N={N} ({time.time()-t1:.0f}s)", flush=True)
    # G1, G2
    t2 = time.time()
    G1 = np.zeros((N, N)); G2 = np.zeros((N, N))
    for i in range(N):
        ci = Counter(keys[i])
        for j in range(i, N):
            cj = Counter(keys[j])
            G1[i, j] = G1[j, i] = G1pair(ci, cj, k)
            G2[i, j] = G2[j, i] = M2pair(ci, cj, k)
    print(f"G1,G2 built ({time.time()-t2:.0f}s)", flush=True)
    W = np.zeros((n, N))
    for i, e in enumerate(row_exps):
        for mu, w in e.items():
            W[i, all_idx[mu]] = w
    t3 = time.time()
    M1 = W @ G1 @ W.T
    M2 = k * (W @ G2 @ W.T)
    print(f"W·G·W^T done ({time.time()-t3:.0f}s)", flush=True)
    d = 1.0 / np.sqrt(np.maximum(np.diag(M1), 1e-300))
    M1s = M1 * d[:, None] * d[None, :]
    M2s = M2 * d[:, None] * d[None, :]
    try:
        L = np.linalg.cholesky(M1s)
    except np.linalg.LinAlgError:
        M1s = M1s + 1e-12 * np.eye(n)
        L = np.linalg.cholesky(M1s)
    Linv = np.linalg.solve(L, np.eye(n))
    B = Linv @ M2s @ Linv.T
    ev = np.linalg.eigvalsh(B)
    lam = float(ev[-1])
    print(f"cond(M1s)={np.linalg.cond(M1s):.2e} lambda_max={lam:.6f} M = {k*lam:.6f} (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
