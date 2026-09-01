#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sanity_check.py — G3 独立审计 (v3, 指数采样, 无拒绝)
1. 低维 kk=3/5: frac_multi 公式矩阵 vs 独立数值积分
   - B (Gram): ∫_{(1+eps)R_kk} e_a e_b
   - J (Maynard 分子, 单切片 i=1 约定): ∫_{t_{≠1}∈(1-eps)R_{kk-1}} (∫_0^L e_a)(∫_0^L e_b) dt_{≠1}
     (J1 为单切片矩阵: M = k·λ_max(J1,B), legendre_fix 的 M=k·λ_max 约定)
2. k=49 D=2: 解析特例 ∫(1+eps-Σt)^r dt = (1+eps)^{k+r}·r!/(k+r)! vs 公式
3. k=49 D=2: Rayleigh 方向: C=(4/k)B−J 正定 ⟺ λ_max(J,B)<4/k ⟺ M<4 ⟺ LDL>0
采样: R_d 均匀点 = z=-log(rng.random(d+1)), y=z[:d]/z.sum()  (指数/归一化, 无拒绝)
体积: vol((1+eps)R_d)=(1+eps)^d/d!, vol((1-eps)R_d)=(1-eps)^d/d!
cnt==0 → RuntimeError。不修改任何已有证书文件。
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

def simplex_samples(d, N, seed):
    """R_d 均匀点 (指数采样): z=-log(U_{d+1}), y=z[:d]/z.sum(). 无拒绝, 命中率 1."""
    rng = np.random.default_rng(seed)
    z = -np.log(rng.random((N, d + 1)) + 1e-300)
    y = z[:, :d] / z.sum(axis=1, keepdims=True)
    return y

def audit_mc(kk, D, N, seed):
    epsf = 1/25; ONE = 1 + epsf
    basis, B, J = build_matrices(kk, D)
    n = len(basis)
    def e_val(b, t):
        r, gamma = b
        w = ONE - sum(t)
        if w <= 0: return 0.0
        v = w ** r
        for d in gamma:
            v *= sum(x ** d for x in t)
        return v
    print(f'[审计1] kk={kk} D={D} n={n} (指数采样 N={N})', flush=True)
    # --- B: t = ONE*y, y ∈ R_kk; volB = ONE^kk/kk! ---
    Y = simplex_samples(kk, N, seed)
    T = ONE * Y
    volB = ONE ** kk / factorial(kk)
    worstB = 0.0
    print('  B 公式 vs MC (独立数值积分):', flush=True)
    for ia in range(n):
        for ib in range(ia, n):
            vals = np.array([e_val(basis[ia], t) * e_val(basis[ib], t) for t in T])
            mc = vals.mean() * volB
            ex = float(B[ia][ib])
            rel = abs(mc - ex) / max(abs(ex), 1e-300)
            worstB = max(worstB, rel)
            flag = 'OK' if rel < 5e-2 else 'MISMATCH'
            print(f'    B[{ia}][{ib}] 公式={ex:.6e} MC={mc:.6e} rel={rel:.1e} {flag}', flush=True)
    # --- J (单切片 i=1): t_{≠1} = (1-eps)y, y ∈ R_{kk-1} ---
    volJ = (1 - epsf) ** (kk - 1) / factorial(kk - 1)
    xg = np.polynomial.legendre.leggauss(24)
    worstJ = 0.0
    print('  J 公式 (单切片 i=1) vs MC:', flush=True)
    for ia in range(n):
        for ib in range(ia, n):
            acc = 0.0
            Yn = simplex_samples(kk - 1, N, seed + 100)
            for y in Yn:
                t_ne = (1 - epsf) * y
                u_ne = t_ne.sum(); L = ONE - u_ne
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
                acc += sl(ia) * sl(ib)
            if N == 0:
                raise RuntimeError('cnt==0: 采样失败')
            mc = acc / N * volJ
            ex = float(J[ia][ib])
            rel = abs(mc - ex) / max(abs(ex), 1e-300)
            worstJ = max(worstJ, rel)
            flag = 'OK' if rel < 5e-2 else 'MISMATCH'
            print(f'    J[{ia}][{ib}] 公式={ex:.6e} MC={mc:.6e} rel={rel:.1e} {flag}', flush=True)
    return worstB, worstJ

def audit_k49_analytic():
    kk = 49; D = 2
    basis, B, J = build_matrices(kk, D)
    print(f'[审计2] k=49 D=2: 解析特例 ∫(1+eps-Σt)^r dt = (1+eps)^{k+r}·r!/(k+r)!', flush=True)
    ok = True
    for ia, (r1, ga) in enumerate(basis):
        if ga != (): continue
        for ib, (r2, gb) in enumerate(basis):
            if gb != (): continue
            rr = r1 + r2
            ana = (1 + 1/25) ** (kk + rr) * factorial(rr) / factorial(kk + rr)
            ex = float(B[ia][ib])
            rel = abs(ex - ana) / ana
            print(f'  B[(r={r1},∅),(r={r2},∅)]: 公式={ex:.10e} 解析={ana:.10e} rel={rel:.1e}', flush=True)
            ok = ok and rel < 1e-12
    print(f'  解析特例全部一致: {ok}', flush=True)
    return basis, B, J

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
    print(f'[审计3] k=49 D=2 Rayleigh 方向链:', flush=True)
    print(f'  λ_max(J,B) = {lam_max:.10e}   4/k = {4/kk:.10e}', flush=True)
    print(f'  λ < 4/k: {lam_max < 4/kk}', flush=True)
    print(f'  M = k·λ_max = {kk*lam_max:.8e}   < 4: {kk*lam_max < 4}', flush=True)
    print(f'  C = (4/k)B−J 最小特征值 = {ceig[0]:.3e}  (C 正定: {ceig[0] > 0})', flush=True)
    print(f'  C 浮点 LDL 全主元 > 0: {ldlt_pos(csym)}', flush=True)
    consistent = (ceig[0] > 0) and (lam_max < 4/kk) and (kk*lam_max < 4) and ldlt_pos(csym)
    print(f'  方向一致 (C 正定 ⟺ λ<4/k ⟺ M<4 ⟺ LDL>0): {consistent} ✓', flush=True)
    return consistent

if __name__ == '__main__':
    print('G3 独立审计 v3 — k=49, eps=1/25 (指数采样, 无拒绝)', flush=True)
    wB3, wJ3 = audit_mc(3, 2, N=150000, seed=11)
    wB5, wJ5 = audit_mc(5, 2, N=100000, seed=13)
    basis, B, J = audit_k49_analytic()
    cons = audit_rayleigh(basis, B, J)
    print(f'汇总: kk=3 worst rel B={wB3:.1e} J={wJ3:.1e}; kk=5 worst rel B={wB5:.1e} J={wJ5:.1e}; 方向一致={cons}', flush=True)
    print('G3 审计完成 (仅输出, 未修改任何已有证书文件)', flush=True)
