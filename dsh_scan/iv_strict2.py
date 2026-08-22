#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""iv_strict2.py — 区间算术严格判定 (对称选主元 LDL^T): M_{k,eps} < 4 ?
A = (4/k)·I − J1 (Fraction 精确) → mpmath iv 区间 (iv.dps 可配)
对称选主元: 每步选最大对角 (区间中点), 行/列同步交换 (PAP^T, 保持惯性),
避免无选主元 LDL 的病态小主元导致的区间传播爆炸。
主元区间全部下界 > 0 ⟹ A 正定 ⟹ λ_max < 4/k ⟹ M < 4 严格。
用法: python3 iv_strict2.py k D eps_num eps_den [dps] [cache]
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

# A 构建 (Fraction → iv 精确转换)
A = iv.matrix(n, n)
mid = iv.mpf(4 * ed) / iv.mpf(k * ed)
for i in range(n):
    for j in range(n):
        A[i, j] = mid * (iv.mpf(I[i][j].numerator) / iv.mpf(I[i][j].denominator)) - (iv.mpf(J1[i][j].numerator) / iv.mpf(J1[i][j].denominator))
print(f'A built ({time.time()-t0:.0f}s); interval LDL^T (symmetric pivoting) ...', flush=True)

# 对称选主元 LDL^T: 维护剩余子矩阵 R (只更新对角列? 全量更新 O(n^3) 太慢)
# 标准方法: 不显式更新整个子矩阵, 用原始 A + L 公式: 在每一步 j,
#   剩余子矩阵 A^{(j)}[i,l] = A[i,l] − Σ_{m<j} L[i][m]·D[m]·L[l][m]
#   对角: A^{(j)}[i,i] = A[i,i] − Σ_{m<j} L[i][m]^2·D[m]
# 选主元需要剩余对角 —— 每步重算候选对角 (j..n) 成本 O((n−j)·j) 可接受。
perm = list(range(n))
D_ = [iv.mpf(0)] * n
L = [[iv.mpf(0)] * n for _ in range(n)]
t1 = time.time()
min_pivot = iv.mpf('inf')
for j in range(n):
    # 计算剩余对角 (候选主元) — 用区间中点选
    best = j; best_mid = None
    for i in range(j, n):
        d = A[i, i]
        for m in range(j):
            Lim = L[i][m]
            d -= Lim * D_[m] * Lim
        if best_mid is None or (d.a + d.b) > (best_mid.a + best_mid.b):
            best = i; best_mid = d
    # 对称交换 best <-> j (perm + A 行/列 + L 已算列)
    if best != j:
        perm[j], perm[best] = perm[best], perm[j]
        for t in range(n):
            A[j, t], A[best, t] = A[best, t], A[j, t]
        for t in range(n):
            A[t, j], A[t, best] = A[t, best], A[t, j]
        for t in range(j):
            L[j][t], L[best][t] = L[best][t], L[j][t]
    # 主元
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
print(f'k={k}: 区间 LDL^T (选主元) 完成 {dt:.0f}s, 全部主元区间下界 > 0', flush=True)
print(f'k={k}: 最小主元区间 = {min_pivot}', flush=True)
print(f'⇒ STRICT: M_{k} < 4  (λ_max < 4/k, 区间算术证书, 对称选主元)', flush=True)
