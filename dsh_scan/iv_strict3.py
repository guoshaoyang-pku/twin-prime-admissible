#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""iv_strict3.py — 区间算术严格判定 (对角平衡 + 对称选主元): M_{k,eps} < 4 ?
A = (4/k)·I − J1 (Fraction 精确) → 对角平衡 A' = D·A·D (D_ii = 1/sqrt(A_ii), 区间),
正对角合同变换保持正定性: A' 正定 ⟺ A 正定。平衡后对角 = 1, 主元 ~O(1),
区间宽度 ~1e-dps 远小于主元, 判定万无一失。再叠加对称选主元保险。
全部主元区间下界 > 0 ⟹ A' 正定 ⟹ A 正定 ⟹ λ_max(J1,I) < 4/k ⟹ M < 4 严格。
用法: python3 iv_strict3.py k D eps_num eps_den [dps] [cache]
"""
import sys, time, pickle
sys.path.insert(0, '.')
import mpmath as mp
iv = mp.iv

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
dps = int(sys.argv[5]) if len(sys.argv) > 5 else 400
cache = sys.argv[6] if len(sys.argv) > 6 else f'frac_cache_{k}_{D}.pkl'
iv.dps = dps

t0 = time.time()
with open(cache, 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
print(f'k={k} D={D} n={n} eps={en}/{ed} dps={dps} cache={cache} loaded', flush=True)

A0 = iv.matrix(n, n)
mid = iv.mpf(4 * ed) / iv.mpf(k * ed)
for i in range(n):
    for j in range(n):
        A0[i, j] = mid * (iv.mpf(I[i][j].numerator) / iv.mpf(I[i][j].denominator)) - (iv.mpf(J1[i][j].numerator) / iv.mpf(J1[i][j].denominator))
print(f'A built ({time.time()-t0:.0f}s); diagonal balancing ...', flush=True)

# 对角平衡 (区间): D_ii = 1/sqrt(A_ii); 若 A_ii 区间含 0 则失败 (正定时不可能)
scale = [iv.mpf(0)] * n
for i in range(n):
    aii = A0[i, i]
    if aii.a <= 0:
        print(f'k={k}: A[{i}][{i}] = {aii} 含非正 → 失败', flush=True)
        sys.exit(1)
    scale[i] = 1 / iv.sqrt(aii)
A = iv.matrix(n, n)
for i in range(n):
    si = scale[i]
    for j in range(n):
        A[i, j] = si * A0[i, j] * scale[j]
print(f'balanced A (diag ≈ 1) ({time.time()-t0:.0f}s); interval LDL^T (symmetric pivoting) ...', flush=True)

perm = list(range(n))
D_ = [iv.mpf(0)] * n
L = [[iv.mpf(0)] * n for _ in range(n)]
t1 = time.time()
min_pivot = iv.mpf('inf')
for j in range(n):
    best = j; best_mid = None
    for i in range(j, n):
        d = A[i, i]
        for m in range(j):
            Lim = L[i][m]
            d -= Lim * D_[m] * Lim
        if best_mid is None or (d.a + d.b) > (best_mid.a + best_mid.b):
            best = i; best_mid = d
    if best != j:
        perm[j], perm[best] = perm[best], perm[j]
        for t in range(n):
            A[j, t], A[best, t] = A[best, t], A[j, t]
        for t in range(n):
            A[t, j], A[t, best] = A[t, best], A[t, j]
        for t in range(j):
            L[j][t], L[best][t] = L[best][t], L[j][t]
    v = A[j, j]
    for m in range(j):
        Ljm = L[j][m]
        v -= Ljm * D_[m] * Ljm
    D_[j] = v
    if v.a <= 0:
        print(f'k={k}: j={j} pivot {v} NOT positive → 判定失败', flush=True)
        sys.exit(1)
    if v.a < min_pivot.a:
        min_pivot = v
    L[j][j] = iv.mpf(1)
    for i in range(j + 1, n):
        s = A[i, j]
        for m in range(j):
            s -= L[i][m] * D_[m] * L[j][m]
        L[i][j] = s / v
    if j % 50 == 0:
        print(f'  j={j}/{n} min_pivot={min_pivot} ({time.time()-t1:.0f}s)', flush=True)
dt = time.time() - t1
print(f'k={k}: 平衡+选主元 区间 LDL^T 完成 {dt:.0f}s, 全部主元区间下界 > 0', flush=True)
print(f'k={k}: 最小主元区间 = {min_pivot}', flush=True)
print(f'⇒ STRICT: M_{k} < 4  (对角平衡 + 对称选主元 + 区间算术证书)', flush=True)
