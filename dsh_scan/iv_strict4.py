#!/usr/bin/env python3
"""iv_strict4.py — 加速版: 对角平衡 + 无选主元区间 LDL^T (dps 可配)
无选主元省去候选扫描 (~1.5-2x); 更低 dps 再 ~2x. 平衡后主元健康时稳定.
用法: python3 iv_strict4.py k D eps_num eps_den [dps] [cache]
"""
import sys, time, pickle
sys.path.insert(0, '.')
import mpmath as mp
iv = mp.iv

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
dps = int(sys.argv[5]) if len(sys.argv) > 5 else 200
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
print(f'balanced A ({time.time()-t0:.0f}s); interval LDL^T (NO pivoting) ...', flush=True)

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
print(f'k={k}: 平衡+无选主元 区间 LDL^T 完成 {dt:.0f}s, 全部主元区间下界 > 0', flush=True)
print(f'k={k}: 最小主元区间 = {min_pivot}', flush=True)
print(f'⇒ STRICT: M_{k} < 4  (对角平衡 + 无选主元 + 区间算术证书, dps={dps})', flush=True)
