#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""diag_cond.py — 诊断 (I, J1) 的条件数结构:
  1. 块结构 (γ → r 块大小)
  2. float64 对角缩放后的 cond (饱和 ~1e16 说明真 cond 更大)
  3. 复现 legendre_eig.py 的块对角 Legendre 变换 → cond (预期 ~4.82e67)
  4. 精确块对角 Jacobi 变换 (正确正交多项式族) + 对角缩放 → cond
     (检验: 块对角正交多项式变换能否把 cond 降到 <1e6?)
用法: python3 diag_cond.py k D
"""
import sys, time, math, pickle
from fractions import Fraction as Fr
from collections import defaultdict
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

def leg_coeff(r):
    return [Fr((-1) ** (r - kk) * math.comb(r, kk) * math.comb(r + kk, kk)) for kk in range(r + 1)]

def pow_coeff(r):
    return [Fr((-1) ** kk * math.comb(r, kk)) for kk in range(r + 1)]

def frac_inv_lower(L):
    """L 单位下三角, 返回 L^{-1} (分数)"""
    m = len(L)
    X = [[Fr(0)] * m for _ in range(m)]
    for i in range(m):
        X[i][i] = Fr(1)
    for i in range(m):
        for j in range(i):  # X[i][j] = -Σ_{k=j}^{i-1} L[i][k] X[k][j]
            s = Fr(0)
            for k in range(j, i):
                s += L[i][k] * X[k][j]
            X[i][j] = -s
    return X

def exact_block_LDL(rows, M):
    """块子矩阵的精确 LDL^T: 返回 (L, d) 使块 = L diag(d) L^T (L 单位下三角, d 有理数)"""
    m = len(rows)
    A = [[M[rows[i]][rows[j]] for j in range(m)] for i in range(m)]
    L = [[Fr(0)] * m for _ in range(m)]
    d = [Fr(0)] * m
    for i in range(m):
        L[i][i] = Fr(1)
        for j in range(i):
            s = A[i][j] - sum(L[i][k] * d[k] * L[j][k] for k in range(j))
            L[i][j] = s / d[j]
        d[i] = A[i][i] - sum(L[i][k] ** 2 * d[k] for k in range(i))
    return L, d

def float_cond(Mf):
    try:
        return float(np.linalg.cond(Mf))
    except Exception as e:
        return float('nan')

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    assert len(basis) == n
    blocks = defaultdict(list)
    for i, (r, gamma) in enumerate(basis):
        blocks[gamma].append(i)
    print(f"k={k} D={D} n={n}  #blocks={len(blocks)}:", flush=True)
    from collections import Counter
    cnt = Counter(len(v) for v in blocks.values())
    print("  size->count:", dict(sorted(cnt.items())), flush=True)

    # ---- float64 基线 ----
    If = np.array([[float(x) for x in row] for row in I])
    Jf = np.array([[float(x) for x in row] for row in J1])
    d = 1.0 / np.sqrt(np.maximum(np.diag(If), 1e-300))
    Is = If * d[:, None] * d[None, :]
    Js = Jf * d[:, None] * d[None, :]
    print(f"[float64] cond(diag-scaled I) = {float_cond(Is):.3e}  (饱和于 ~1e16 表示真值更大)", flush=True)
    print(f"[float64] cond(diag-scaled J1) = {float_cond(Js):.3e}", flush=True)

    # ---- 复现 legendre_eig.py: 块对角 Legendre 变换 ----
    def legendre_block_transform(M):
        Ml = [row[:] for row in M]
        for gamma, rows in blocks.items():
            m = len(rows)
            A = [[Fr(0)] * m for _ in range(m)]
            L = [[Fr(0)] * m for _ in range(m)]
            for r in range(m):
                for kk in range(r + 1):
                    A[r][kk] = pow_coeff(r)[kk]
                    L[r][kk] = leg_coeff(r)[kk]
            Mb = [[Ml[rows[i]][rows[j]] for j in range(m)] for i in range(m)]
            Ainv = frac_inv_lower(A)
            B = [[sum(Ainv[i][p] * Mb[p][q] * Ainv[j][q] for p in range(m) for q in range(m)) for j in range(m)] for i in range(m)]
            Linv = frac_inv_lower(L)
            C = [[sum(Linv[i][p] * B[p][q] * Linv[j][q] for p in range(m) for q in range(m)) for j in range(m)] for i in range(m)]
            for i in range(m):
                for j in range(m):
                    Ml[rows[i]][rows[j]] = C[i][j]
        return Ml

    t1 = time.time()
    Il = legendre_block_transform(I)
    print(f"[legendre block-diag transform] done ({time.time()-t1:.0f}s)", flush=True)
    Ilf = np.array([[float(x) for x in row] for row in Il])
    d2 = 1.0 / np.sqrt(np.maximum(np.diag(Ilf), 1e-300))
    Ils = Ilf * d2[:, None] * d2[None, :]
    print(f"[legendre] cond(diag-scaled transformed I) = {float_cond(Ils):.3e}  (复现用户报告 ~4.82e67)", flush=True)

    # ---- 正确 Jacobi 正交多项式: 块内精确对角化 (LDL 检验) ----
    # 块内 Hankel 结构: 块(γ) = H(γ∪γ;k)·(r1+r2)!/(k+2|γ|+r1+r2)!; 正确正交多项式 = Jacobi P^{(0, k+2|γ|-1)}
    t2 = time.time()
    # 先验证一块: 精确 LDL 后是否精确对角
    g0 = parts[0]  # ()
    rows0 = blocks[g0]
    L0, d0 = exact_block_LDL(rows0, I)
    m0 = len(rows0)
    # 检查 L0 diag(d0) L0^T 是否复原块
    R = [[sum(L0[i][p] * d0[p] * L0[j][p] for p in range(min(i, j) + 1)) for j in range(m0)] for i in range(m0)]
    ok = all(R[i][j] == I[rows0[i]][rows0[j]] for i in range(m0) for j in range(m0))
    print(f"[jacobi check] block γ=() m={m0}: exact LDL^T reproduces block: {ok}; d range {float(d0[-1]):.3e}..{float(d0[0]):.3e}", flush=True)

    # 全矩阵: 块对角 Jacobi 正交化作为真正的合同变换 M' = T M T^T (T 块对角, T_γ = D^{-1/2} L^{-1})
    # 注意: 必须同时变换跨块 (α,β) 条目, 否则不是合同变换 (上一版 bug 只变对角块).
    def jacobi_congruence(M):
        Tblocks = {}
        for gamma, rows in blocks.items():
            Lf, df = exact_block_LDL(rows, I)  # 用 I 的块 LDL (同一基变换用于 I 与 J1)
            Linv = frac_inv_lower(Lf)
            sd = [1.0 / math.sqrt(float(df[p].numerator) / float(df[p].denominator)) for p in range(len(rows))]
            Tblocks[gamma] = [[float(Linv[i][p]) * sd[i] for p in range(len(rows))] for i in range(len(rows))]
        Ml = [[0.0] * n for _ in range(n)]
        for ga, ra in blocks.items():
            Ta = Tblocks[ga]
            for gb, rb in blocks.items():
                Tb = Tblocks[gb]
                for i, ri in enumerate(ra):
                    for j, rj in enumerate(rb):
                        s = 0.0
                        for p, rp in enumerate(ra):
                            tap = Ta[i][p]
                            if tap == 0.0:
                                continue
                            for q, rq in enumerate(rb):
                                s += tap * float(M[rp][rq]) * Tb[j][q]
                        Ml[ri][rj] = s
        return Ml

    Ij = jacobi_congruence(I)
    Jj = jacobi_congruence(J1)
    print(f"[jacobi block-diag congruence] done ({time.time()-t2:.0f}s)", flush=True)
    Ijf = np.array(Ij)
    Jjf = np.array(Jj)
    print(f"[jacobi] cond(transformed I, full congruence) = {float_cond(Ijf):.3e}", flush=True)
    print(f"[jacobi] cond(transformed J1, full congruence) = {float_cond(Jjf):.3e}", flush=True)
    # 块内应精确为 1 (对角化): 检查一个块
    b0 = Ijf[rows0[0]:rows0[-1] + 1, rows0[0]:rows0[-1] + 1]
    off = np.abs(b0 - np.eye(m0)).max()
    print(f"[jacobi] block γ=() off-diagonal residual = {off:.2e}", flush=True)
    # 跨块耦合强度: 非对角块范数 / 对角块范数
    offmax = 0.0
    for ga, ra in blocks.items():
        for gb, rb in blocks.items():
            if ga <= gb:
                continue
            B = Ijf[np.ix_(ra, rb)]
            offmax = max(offmax, np.abs(B).max())
    print(f"[jacobi] max cross-block |entry| of transformed I = {offmax:.3e} (对角块 = 1)", flush=True)
    # 若 cond < 1e10, 尝试 float64 广义特征值看 M
    try:
        ev = np.linalg.eigvalsh(Ijf)
        print(f"[jacobi] eig range of transformed I: {ev[0]:.3e} .. {ev[-1]:.3e}", flush=True)
        if ev[0] > 1e-12:
            Lc = np.linalg.cholesky(Ijf)
            Linv = np.linalg.solve(Lc, np.eye(n))
            B = Linv @ Jjf @ Linv.T
            wev = np.linalg.eigvalsh(B)
            print(f"[jacobi] float64 M = {k * wev[-1]:.6f}  λ_max = {wev[-1]:.8f}", flush=True)
        else:
            print(f"[jacobi] transformed I not SPD in float64 (min eig {ev[0]:.2e}) — float64 仍不可靠", flush=True)
    except Exception as e:
        print(f"[jacobi] float64 eig failed: {type(e).__name__}: {e}", flush=True)
    print(f"total {time.time()-t0:.0f}s", flush=True)

if __name__ == '__main__':
    main()
