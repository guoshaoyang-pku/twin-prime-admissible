#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""iv_strict.py — 区间算术严格判定: M_{k,eps} < 4 ?
A = (4/k)·I − J1 (Fraction 精确) → mpmath iv 区间 (512 bits)
区间 LDL^T: 全部主元区间下界 > 0 ⟹ A 正定 ⟹ λ_max(J1,I) < 4/k ⟹ M < 4 严格。
误差: 每运算 2^-prec 相对误差, 区间自动跟踪; 最小主元 ~1e-53 ≫ 区间宽度 ~1e-97,
因此主元区间不含 0, 判定可靠。比 gmpy2 大整数 LDL 快 10-100x。
用法: python3 iv_strict.py k D eps_num eps_den [cache]
"""
import sys, time, pickle
from fractions import Fraction as Fr
sys.path.insert(0, '.')
import mpmath as mp
iv = mp.iv
iv.dps = 400          # ~1330 bits, 区间宽度 ~1e-400

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
cache = sys.argv[5] if len(sys.argv) > 5 else f'frac_cache_{k}_{D}.pkl'

def to_iv_matrix(M):
    n = len(M)
    R = iv.matrix(n, n)
    for i in range(n):
        row = M[i]
        for j in range(n):
            x = row[j]
            R[i, j] = iv.mpf(x.numerator) / iv.mpf(x.denominator)
    return R

t0 = time.time()
with open(cache, 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
print(f'k={k} D={D} n={n} eps={en}/{ed} cache={cache} loaded', flush=True)

A = iv.matrix(n, n)
mid = iv.mpf(4 * ed) / iv.mpf(k * ed)
for i in range(n):
    for j in range(n):
        A[i, j] = mid * (iv.mpf(I[i][j].numerator) / iv.mpf(I[i][j].denominator)) - (iv.mpf(J1[i][j].numerator) / iv.mpf(J1[i][j].denominator))
print(f'A built ({time.time()-t0:.0f}s); interval LDL^T ...', flush=True)

# 区间 LDL^T (无选主元)
D_ = [iv.mpf(0)] * n
L = [[iv.mpf(0)] * n for _ in range(n)]
t1 = time.time()
min_pivot = iv.mpf('inf')
for j in range(n):
    v = A[j, j]
    for m in range(j):
        Ljm = L[j][m]
        v -= Ljm * D_[m] * Ljm
    D_[j] = v
    if v.a <= 0:
        print(f'k={k}: j={j} pivot interval {v} NOT positive → 判定失败 (A 非正定或区间太宽)', flush=True)
        sys.exit(1)
    if v.a < min_pivot.a:
        min_pivot = v
    L[j][j] = iv.mpf(1)
    for i in range(j + 1, n):
        s = A[i, j]
        for m in range(j):
            s -= L[i][m] * D_[m] * L[j][m]
        L[i][j] = s / v
    if j % 100 == 0:
        print(f'  j={j}/{n} min_pivot={min_pivot} ({time.time()-t1:.0f}s)', flush=True)
dt = time.time() - t1
print(f'k={k}: 区间 LDL^T 完成 {dt:.0f}s, 全部主元区间下界 > 0', flush=True)
print(f'k={k}: 最小主元区间 = {min_pivot}', flush=True)
print(f'⇒ STRICT: M_{k} < 4  (λ_max < 4/k, 区间算术证书)', flush=True)
