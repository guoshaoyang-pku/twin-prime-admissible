#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""legendre_eig.py — 从 Fraction 矩阵出发, 精确 Legendre 基变换消除 (1-P1)^r 病态,
然后 float64 特征值 (条件数好)。
基: {(1-P1)^r p_γ} (幂和 mixed) → {(1-x)^r} → {P*_r(x)} (位移 Legendre, x=P1)
P*_r(x) = Σ_{k≤r} l_{rk} x^k,  l = 位移 Legendre 系数 (整数/有理数)
(1-x)^r = Σ_k C(r,k)(-1)^k x^k
变换: M1_leg = L^{-T} A^{-T} M1 A^{-1} L^{-1},  A: (1-x)基→x基, L: Leg基→x基
块对角 (每 γ 一块), 分数精确变换, 然后 numpy 特征值。
"""
import sys, time, math, pickle
from fractions import Fraction as Fr
import numpy as np

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    print(f"loaded k={k} D={D} n={n}", flush=True)
    # 重建基 (与 fraction_mixed 相同顺序)
    def gen_even_partitions(max_deg):
        res = []
        def rec(deg_used, parts):
            res.append(tuple(parts))
            start = parts[-1] if parts else 2
            for v in range(start, max_deg - deg_used + 1, 2):
                rec(deg_used + v, parts + [v])
        rec(0, [])
        return res
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    assert len(basis) == n
    # 块结构: 按 γ 分组
    from collections import defaultdict
    blocks = defaultdict(list)
    for i, (r, gamma) in enumerate(basis):
        blocks[gamma].append(i)
    # 位移 Legendre 系数 P*_r(x) = Σ_{k=0..r} l_{rk} x^k  (x = P1, 区间 [0,1])
    # 标准: P*_r(x) = Σ_{k=0..r} (-1)^{r-k} C(r,k) C(r+k,k) x^k
    def leg_coeff(r):
        return [Fr((-1) ** (r - kk) * math.comb(r, kk) * math.comb(r + kk, kk)) for kk in range(r + 1)]
    def pow_coeff(r):  # (1-x)^r 的 x 展开
        return [Fr((-1) ** kk * math.comb(r, kk)) for kk in range(r + 1)]
    # 变换: 每个块: M' = T M T^T, T = L^{-1} A (A: (1-x)→x, L: Leg→x)
    # x 基 → (1-x) 基: (1-x)^r = Σ_k pow_coeff(r)[k] x^k ⟹ M_{1x} = A M_{(1-x)} A^T
    # x 基 → Leg: P*_r = Σ_k leg(r)[k] x^k ⟹ M_{1x} = L M_leg L^T
    # ⟹ M_leg = L^{-1} A M_{(1-x)} A^T L^{-T}
    # A[r,k] = pow_coeff(r)[k] (行 r = (1-x)^r, 列 k = x^k), 块大小 m = D-|γ|+1
    def transform_block(rows, M):
        m = len(rows)
        A = [[Fr(0)] * m for _ in range(m)]
        L = [[Fr(0)] * m for _ in range(m)]
        for r in range(m):
            for kk in range(r + 1):
                A[r][kk] = pow_coeff(r)[kk]
                L[r][kk] = leg_coeff(r)[kk]
        # 块子矩阵
        Mb = [[M[rows[i]][rows[j]] for j in range(m)] for i in range(m)]
        # A 的逆 (下三角, 对角 1): 前代
        Ainv = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            Ainv[i][i] = Fr(1)
        for col in range(m):
            for row in range(col + 1, m):
                f = A[row][col]  # 对角 = 1
                for jj in range(m):
                    Ainv[row][jj] -= f * Ainv[col][jj]
        # B = Ainv Mb Ainv^T  (M_x = A^{-1} M_{(1-x)} A^{-T})
        B = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                s = Fr(0)
                for p in range(m):
                    for q in range(m):
                        s += Ainv[i][p] * Mb[p][q] * Ainv[j][q]
                B[i][j] = s
        # L^{-1} (上三角? 下三角?) — L[r,k] r≥k 是下三角 (r 行, k 列, k≤r)
        # 解 L X = B 的行? — 我们求 C = L^{-1} B L^{-T}
        # 用分数高斯消元解 L X = I (小 m, ≤28)
        Linv = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            Linv[i][i] = Fr(1)
        # 前代: L 是下三角 (L[r,k], k≤r): 行 r = Σ_{k≤r} L[r,k] x_k
        for col in range(m):
            for row in range(col, m):
                if row == col:
                    continue
                f = L[row][col] / L[col][col]
                for jj in range(m):
                    L[row][jj] -= f * L[col][jj]
                    Linv[row][jj] -= f * Linv[col][jj]
        for row in range(m):
            d = L[row][row]
            for jj in range(m):
                Linv[row][jj] /= d
        # C = Linv B Linv^T
        C = [[Fr(0)] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                s = Fr(0)
                for p in range(m):
                    for q in range(m):
                        s += Linv[i][p] * B[p][q] * Linv[j][q]
                C[i][j] = s
        # 写回
        for i in range(m):
            for j in range(m):
                M[rows[i]][rows[j]] = C[i][j]
    t1 = time.time()
    Il = [row[:] for row in I]
    Jl = [row[:] for row in J1]
    for gamma, rows in blocks.items():
        transform_block(rows, Il)
        transform_block(rows, Jl)
    print(f"Legendre transform done ({time.time()-t1:.0f}s)", flush=True)
    # 转 float64 + numpy 广义特征值
    t2 = time.time()
    M1f = np.array([[float(x.numerator) / float(x.denominator) for x in row] for row in Il])
    M2f = np.array([[float(x.numerator) / float(x.denominator) for x in row] for row in Jl])
    d = 1.0 / np.sqrt(np.maximum(np.diag(M1f), 1e-300))
    M1s = M1f * d[:, None] * d[None, :]
    M2s = M2f * d[:, None] * d[None, :]
    try:
        Lc = np.linalg.cholesky(M1s)
    except np.linalg.LinAlgError:
        M1s = M1s + 1e-12 * np.eye(n)
        Lc = np.linalg.cholesky(M1s)
    Linv = np.linalg.solve(Lc, np.eye(n))
    B = Linv @ M2s @ Linv.T
    ev = np.linalg.eigvalsh(B)
    lam = float(ev[-1])
    print(f"cond(M1s)={np.linalg.cond(M1s):.2e} lambda_max={lam:.6f} M = {k*lam:.6f} (total {time.time()-t2:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
