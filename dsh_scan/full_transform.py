#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""full_transform.py — 完整基变换消除病态:
(1-P1)^r p_γ (幂和 mixed, 精确矩阵) → (1-P1)^r m_μ (对称单项式) → P*_r(P1) m_μ (Legendre)
变换 T1: p_γ → m_μ (迭代 single_col_mul, γ 偶数的幂和展开)
变换 T2: (1-P1)^r → P*_r (位移 Legendre, 块对角)
M_m = T1 M_p T1^T (分数),  M_leg = T2 M_m T2^T (分数)
然后 float64 广义特征值 (条件数应大幅改善)
用法: python3 full_transform.py k D
"""
import sys, time, math, pickle
from collections import Counter, defaultdict
from fractions import Fraction as Fr
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

def single_col_mul(r, beta):
    """m_(r)·m_β = {γ: c}"""
    res = {}
    b = list(beta)
    for v in set(b):
        g = list(b); g.remove(v); g.append(v + r)
        g = tuple(sorted(g, reverse=True))
        res[g] = res.get(g, 0) + g.count(v + r)
    g = tuple(sorted(b + [r], reverse=True))
    res[g] = res.get(g, 0) + g.count(r)
    return {k: v for k, v in res.items() if v != 0}

def pgamma_to_m(gamma):
    """p_γ = ∏ m_{γ_i} 的 m 基展开 (迭代)"""
    table = {(): 1}
    for v in gamma:
        new = {}
        for mu, c in table.items():
            for nu, c2 in single_col_mul(v, mu).items():
                new[nu] = new.get(nu, 0) + c * c2
        table = new
    return table

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    print(f"loaded k={k} D={D} n={n}", flush=True)
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    assert len(basis) == n
    # T1: p_γ → m_μ 展开 (γ → μ 系数)
    t1 = time.time()
    gamma_exp = {gamma: pgamma_to_m(gamma) for gamma in parts}
    # 收集所有 μ
    all_mu = set()
    for gamma, tbl in gamma_exp.items():
        for mu in tbl:
            all_mu.add(mu)
    mu_list = sorted(all_mu, key=lambda m: (sum(m), m))
    mu_idx = {m: i for i, m in enumerate(mu_list)}
    NM = len(mu_list)
    print(f"p→m expansions done ({time.time()-t1:.0f}s), NM={NM}", flush=True)
    # T1 矩阵 (n × (D+1) × NM): T1[(r,γ) 行, (r,μ) 列] = 系数 (r 不变)
    # 直接做: M_m[(r1,γ1),(r2,γ2)] = Σ_{μ,ν} c1(γ1,μ) c2(γ2,ν) M_p[(r1,μ),(r2,ν)]
    # 但 M_p 只在 γ 空间有值——把 M_p 视为 μ 空间的 (零填充) ——
    # M_m = T1 M_p T1^T 用块结构: 对每个 r1, r2:
    t2 = time.time()
    # 索引: 每 γ 的 r 范围 [0, D-|γ|]
    # 建 γ 的 r-索引映射
    gamma_r_max = {gamma: D - sum(gamma) for gamma in parts}
    def idx(r, gamma):
        # 基顺序: for gamma in parts: for r in 0..D-|γ|
        off = 0
        for g in parts:
            if g == gamma:
                return off + r
            off += (D - sum(g)) + 1
        raise KeyError
    # 结果矩阵 M_m (分数)
    Mm = [[Fr(0)] * n for _ in range(n)]
    # 预计算 γ1×γ2 的合并系数对 (μ,ν,coef)
    pair_cache = {}
    for i1, (r1, g1) in enumerate(basis):
        e1 = gamma_exp[g1]
        for i2, (r2, g2) in enumerate(basis):
            if (g1, g2) not in pair_cache:
                lst = []
                for mu, c1 in e1.items():
                    for nu, c2 in gamma_exp[g2].items():
                        # 需要 M_p 在 (r1,μ),(r2,ν) —— μ,ν 必须是 γ (在 parts 中) 才有值
                        if mu in gamma_r_max and nu in gamma_r_max:
                            lst.append((idx(r1, mu), idx(r2, nu), c1 * c2))
                pair_cache[(g1, g2)] = lst
            s = Fr(0)
            for a, b, c in pair_cache[(g1, g2)]:
                s += c * I[a][b]
            Mm[i1][i2] = s
    print(f"M_m built ({time.time()-t2:.0f}s)", flush=True)
    # T2: Legendre (块对角, r 部分)
    t3 = time.time()
    Mleg = [row[:] for row in Mm]
    # 块 = 每 γ 的 r 子矩阵
    for gamma in parts:
        rows = [idx(r, gamma) for r in range(0, D - sum(gamma) + 1)]
        m = len(rows)
        # L[r,k] = leg_coeff(r)[k] (下三角), L^{-1} 前代
        L = [[Fr(0)] * m for _ in range(m)]
        for r in range(m):
            for kk in range(r + 1):
                L[r][kk] = Fr((-1) ** (r - kk) * math.comb(r, kk) * math.comb(r + kk, kk))
        Linv = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            Linv[i][i] = Fr(1)
        for col in range(m):
            for row in range(col + 1, m):
                f = L[row][col] / L[col][col]
                for jj in range(m):
                    Linv[row][jj] -= f * Linv[col][jj]
        for row in range(m):
            d = L[row][row]
            for jj in range(m):
                Linv[row][jj] /= d
        # M_leg 块 = Linv M_m块 Linv^T
        B = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                s = Fr(0)
                for p in range(m):
                    for q in range(m):
                        s += Linv[i][p] * Mleg[rows[p]][rows[q]] * Linv[j][q]
                B[i][j] = s
        for i in range(m):
            for j in range(m):
                Mleg[rows[i]][rows[j]] = B[i][j]
    print(f"M_leg done ({time.time()-t3:.0f}s)", flush=True)
    # 同样变换 J1
    Jm = [[Fr(0)] * n for _ in range(n)]
    for i1, (r1, g1) in enumerate(basis):
        for i2, (r2, g2) in enumerate(basis):
            s = Fr(0)
            for a, b, c in pair_cache[(g1, g2)]:
                s += c * J1[a][b]
            Jm[i1][i2] = s
    Jleg = [row[:] for row in Jm]
    for gamma in parts:
        rows = [idx(r, gamma) for r in range(0, D - sum(gamma) + 1)]
        m = len(rows)
        L = [[Fr(0)] * m for _ in range(m)]
        for r in range(m):
            for kk in range(r + 1):
                L[r][kk] = Fr((-1) ** (r - kk) * math.comb(r, kk) * math.comb(r + kk, kk))
        Linv = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            Linv[i][i] = Fr(1)
        for col in range(m):
            for row in range(col + 1, m):
                f = L[row][col] / L[col][col]
                for jj in range(m):
                    Linv[row][jj] -= f * Linv[col][jj]
        for row in range(m):
            d = L[row][row]
            for jj in range(m):
                Linv[row][jj] /= d
        B = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                s = Fr(0)
                for p in range(m):
                    for q in range(m):
                        s += Linv[i][p] * Jleg[rows[p]][rows[q]] * Linv[j][q]
                B[i][j] = s
        for i in range(m):
            for j in range(m):
                Jleg[rows[i]][rows[j]] = B[i][j]
    print(f"J_leg done", flush=True)
    # float64 特征值
    t4 = time.time()
    M1f = np.array([[float(x.numerator) / float(x.denominator) for x in row] for row in Mleg])
    M2f = np.array([[float(x.numerator) / float(x.denominator) for x in row] for row in Jleg])
    d = 1.0 / np.sqrt(np.maximum(np.diag(M1f), 1e-300))
    M1s = M1f * d[:, None] * d[None, :]
    M2s = M2f * d[:, None] * d[None, :]
    print(f"cond(M1s)={np.linalg.cond(M1s):.2e}", flush=True)
    try:
        Lc = np.linalg.cholesky(M1s)
    except np.linalg.LinAlgError:
        M1s = M1s + 1e-10 * np.eye(n)
        Lc = np.linalg.cholesky(M1s)
    Linv = np.linalg.solve(Lc, np.eye(n))
    B = Linv @ M2s @ Linv.T
    ev = np.linalg.eigvalsh(B)
    lam = float(ev[-1])
    print(f"RESULT k={k} D={D}: lambda_max={lam:.6f} M = {k*lam:.6f} (total {time.time()-t4:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
