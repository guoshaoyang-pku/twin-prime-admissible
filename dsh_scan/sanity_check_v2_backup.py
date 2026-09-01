#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sanity_check.py — G3 独立审计 (v2)
1. 低维 kk=5: frac_multi 公式矩阵 vs 直接数值积分 (MC 可行) — 验证公式结构
2. k=49 D=2: 解析特例 (∫(1+eps-Sigma t)^r = (1+eps)^{k+r}·r!/(k+r)!) vs 公式
3. k=49 D=2: Rayleigh 方向: C=(4/k)B−J 正定 ⟺ λ_max(J,B)<4/k ⟺ M=k·λ<4 ⟺ LDL>0
不修改任何已有证书文件。
"""
import sys, math
sys.path.insert(0, '.')
from fractions import Fraction as Fr
from math import factorial, comb
import numpy as np

def gen_even_partitions(max_deg):
    res = []
    def rec(d, ps):
        res.append(tuple(ps))
        start = ps[-1] if ps else 2
        for v in range(start, max_deg - d + 1, 2):
            rec(d + v, ps + [v])
    rec(0, [])
    return res

def build_basis(D):
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    return basis

def split_a(parts):
    from collections import Counter
    cnt = Counter(parts); res = []; vals = sorted(cnt)
    def rec(i, chosen, S, rest):
        if i == len(vals):
            res.append((math.prod(math.comb(cnt[v], j) for v, j in chosen), S, tuple(sorted(rest))))
            return
        v = vals[i]
        for j in range(cnt[v] + 1):
            rec(i + 1, chosen + [(v, j)], S + j * v, rest + [v] * (cnt[v] - j))
    rec(0, [], 0, [])
    return res

def H_exact(parts, coords, cache):
    key = (tuple(sorted(parts)), coords)
    v = cache.get(key)
    if v is not None: return v
    dp = {(): Fr(1)}
    for val in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx in range(len(state)):
                if idx > 0 and state[idx - 1] == state[idx]: continue
                mult = state.count(state[idx])
                ns = list(state); ns[idx] += val; ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, Fr(0)) + cnt * mult
            ns = tuple(sorted(state + (val,)))
            ndp[ns] = ndp.get(ns, Fr(0)) + cnt
        dp = ndp
    tot = Fr(0)
    for state, cnt in dp.items():
        if len(state) <= coords:
            f = factorial(coords) // factorial(coords - len(state))
            tot += cnt * math.prod(factorial(s) for s in state) * f
    cache[key] = tot
    return tot

def build_matrices(kk, D):
    """frac_multi 公式 (参数化 kk), 返回 (basis, B, J) 精确有理"""
    eps = Fr(1, 25)
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    n = len(basis)
    fac = {m2: factorial(m2) for m2 in range(0, 3 * D + 2 * kk + 100)}
    Hc = {}
    for coords in (kk, kk - 1):
        for gamma in parts:
            H_exact(list(gamma), coords, Hc)
        for gamma in parts:
            for delta in parts:
                H_exact(list(sorted(gamma + delta)), coords, Hc)
    Gtab = {}
    for s in range(0, 2 * D + 3):
        for dmu in range(0, 2 * D + 1):
            tot = Fr(0)
            for j in range(s + 1):
                tot += Fr(comb(s, j)) * ((1 - eps) ** j) * ((2 * eps) ** (s - j)) * Fr(fac[j], fac[kk - 1 + j + dmu])
            Gtab[(s, dmu)] = tot
    e1 = [Fr(1)]
    for _ in range(kk + 2 * D + 5): e1.append(e1[-1] * (1 + eps))
    c1 = [Fr(1)]
    for _ in range(kk + 3 * D + 5): c1.append(c1[-1] * (1 - eps))
    splits = {gamma: split_a(list(gamma)) for gamma in parts}
    B = [[Fr(0)] * n for _ in range(n)]
    J = [[Fr(0)] * n for _ in range(n)]
    for ia, (r1, alpha) in enumerate(basis):
        for ib, (r2, beta) in enumerate(basis):
            gamma = tuple(sorted(alpha + beta)); deg = sum(gamma); rr = r1 + r2
            B[ia][ib] = e1[kk + deg + rr] * Fr(fac[rr]) * H_exact(list(gamma), kk, Hc) / Fr(fac[kk + rr + deg])
            tots = Fr(0)
            for ca, Sa, ga in splits[alpha]:
                Ba = Fr(fac[r1] * fac[Sa], fac[r1 + Sa + 1])
                for cb, Sb, gb in splits[beta]:
                    Bb = Fr(fac[r2] * fac[Sb], fac[r2 + Sb + 1])
                    mu = tuple(sorted(ga + gb)); dmu = sum(mu); s = rr + 2 + Sa + Sb
                    coef = ca * cb * Ba * Bb * H_exact(list(mu), kk - 1, Hc)
                    tots += coef * c1[kk - 1 + dmu] * Gtab[(s, dmu)]
            J[ia][ib] = tots
    return basis, B, J

# ---------- 1. 低维 kk=5 MC 审计 ----------
def audit_mc(kk, D, N=80000, seed=5):
    epsf = 1/25; ONE = 1 + epsf
    basis, B, J = build_matrices(kk, D)
    n = len(basis)
    def e_val(b, t):
        r, gamma = b
        w = ONE - sum(t)
        v = w ** r
        for d in gamma:
            v *= sum(x ** d for x in t)
        return v if w > 0 else 0.0
    rng = np.random.default_rng(seed)
    print(f'[审计1] kk={kk} D={D} n={n}: B 公式 vs MC (均匀 (1+eps)R_{kk})')
    for ia in range(min(n, 4)):
        for ib in range(ia, min(n, 4)):
            acc = 0.0; cnt = 0
            for _ in range(N):
                y = rng.random(kk)
                if y.sum() > 1: continue
                t = ONE * y
                acc += e_val(basis[ia], t) * e_val(basis[ib], t); cnt += 1
            mc = acc / cnt * ONE ** kk / factorial(kk)
            ex = float(B[ia][ib])
            print(f'  B[{ia}][{ib}]: 公式={ex:.6e} MC={mc:.6e} rel={abs(mc-ex)/max(abs(ex),1e-300):.1e}')
    print(f'  [审计1b] J_{kk}/k vs MC 切片积分 (t_{{≠1}} ∈ (1-eps)R_{{kk-1}})')
    rng2 = np.random.default_rng(seed + 1)
    for ia in range(min(n, 3)):
        for ib in range(ia, min(n, 3)):
            acc = 0.0; cnt = 0
            for _ in range(N):
                y = rng2.random(kk - 1)
                if y.sum() > 1: continue
                t_ne = (1 - epsf) * y
                u_ne = t_ne.sum(); L = ONE - u_ne
                xg = np.polynomial.legendre.leggauss(16)
                xs = L * (xg[0] + 1) / 2; ws = xg[1] * L / 2
                def sl(b_idx):
                    r, gamma = basis[b_idx]
                    vv = []
                    for x in xs:
                        w = L - x
                        v = w ** r
                        for d in gamma:
                            v *= (x ** d + sum(tj ** d for tj in t_ne))
                        vv.append(v)
                    return sum(ww * v for ww, v in zip(ws, vv))
                acc += sl(ia) * sl(ib); cnt += 1
            mc = acc / cnt * (1 - epsf) ** (kk - 1) / factorial(kk - 1)
            ex1 = float(J[ia][ib]) / kk   # J = Σ_i = kk × (i=1 项)
            print(f'  J[{ia}][{ib}]/k: 公式={ex1:.6e} MC={mc:.6e} rel={abs(mc-ex1)/max(abs(ex1),1e-300):.1e}')

# ---------- 2. k=49 解析特例 ----------
def audit_k49_analytic():
    kk = 49; D = 2
    basis, B, J = build_matrices(kk, D)
    n = len(basis)
    print(f'\n[审计2] k=49 D=2: 解析特例 ∫(1+eps-Σt)^r dt = (1+eps)^{k+r}·r!/(k+r)!')
    ok = True
    for ia, (r1, ga) in enumerate(basis):
        if ga != (): continue
        for ib, (r2, gb) in enumerate(basis):
            if gb != (): continue
            rr = r1 + r2
            ana = (1 + 1/25) ** (kk + rr) * factorial(rr) / factorial(kk + rr)
            ex = float(B[ia][ib])
            rel = abs(ex - ana) / ana
            print(f'  B[(r={r1},∅),(r={r2},∅)]: 公式={ex:.6e} 解析={ana:.6e} rel={rel:.1e}')
            ok = ok and rel < 1e-12
    print(f'  解析特例全部一致: {ok}')
    return basis, B, J

# ---------- 3. Rayleigh 方向链 ----------
def audit_rayleigh(basis, B, J):
    kk = 49
    n = len(basis)
    Bf = np.array([[float(x) for x in row] for row in B])
    Jf = np.array([[float(x) for x in row] for row in J])
    from scipy.linalg import eigh
    lam = eigh(Jf, Bf, eigvals_only=True)
    lam_max = lam[-1]
    C = (4 / kk) * Bf - Jf
    csym = (C + C.T) / 2
    ceig = np.linalg.eigvalsh(csym)
    def ldlt_pos(M):
        A = M.astype(float).copy(); n2 = len(M); D = np.zeros(n2)
        for i in range(n2):
            D[i] = A[i, i]
            if D[i] <= 0: return False
            for j in range(i + 1, n2):
                A[j, i] /= D[i]
                A[j, i+1:] -= A[j, i] * A[i, i+1:]
        return all(d > 0 for d in D)
    print(f'\n[审计3] k=49 D=2 Rayleigh 方向链:')
    print(f'  λ_max(J,B) = {lam_max:.10f}  4/k = {4/kk:.10f}  λ < 4/k: {lam_max < 4/kk}')
    print(f'  M = k·λ_max = {kk*lam_max:.8f}  < 4: {kk*lam_max < 4}')
    print(f'  C = (4/k)B−J 最小特征值 = {ceig[0]:.3e}  (正定: {ceig[0] > 0})')
    print(f'  C 浮点 LDL 正定: {ldlt_pos(csym)}')
    print(f'  方向一致 (C 正定 ⟺ λ<4/k ⟺ M<4): {ceig[0] > 0 and lam_max < 4/kk and kk*lam_max < 4} ✓')
    # 健全性: 若把 4/k 换成更大的数, C 更正定; 换 4.0001/k 判据的敏感性
    lam2 = eigh((4.0001 / kk) * Bf - Jf + 1e-30 * np.eye(n), eigvals_only=True)
    print(f'  对照: C + δI (δ=1e-30) 特征值仍正: {lam2[0] > 0}')

if __name__ == '__main__':
    audit_mc(5, 2, N=60000, seed=5)      # 低维公式结构审计
    basis, B, J = audit_k49_analytic()   # k=49 解析特例
    audit_rayleigh(basis, B, J)          # Rayleigh 方向链
    print('\nG3 审计完成 (仅输出, 未修改任何文件)')
