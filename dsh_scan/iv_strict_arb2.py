#!/usr/bin/env python3
"""iv_strict_arb2.py — flint arb 区间算术 + 对称选主元: M_{k,eps} < 4 ?
A = (4/k)·I − J1 (Fraction 精确) → arb 区间 (flint.ctx.prec bits, 正确舍入)
→ 对角平衡 → 对称选主元区间 LDL^T (arb C 级速度, ~10-30x 于 mpmath iv)
全部主元下界 > 0 ⟹ A 正定 ⟹ M < 4 严格.
用法: python3 iv_strict_arb2.py k D eps_num eps_den [prec] [cache]
"""
import sys, time, pickle
sys.path.insert(0, '.')
from flint import arb, arb_mat
import flint

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
prec = int(sys.argv[5]) if len(sys.argv) > 5 else 800
cache = sys.argv[6] if len(sys.argv) > 6 else f'frac_cache_{k}_{D}.pkl'
flint.ctx.prec = prec

t0 = time.time()
with open(cache, 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
print(f'k={k} D={D} n={n} eps={en}/{ed} prec={prec} cache={cache} loaded', flush=True)

mid = arb(4 * ed) / arb(k * ed)
A = arb_mat(n, n)
for i in range(n):
    for j in range(n):
        A[i, j] = mid * (arb(int(I[i][j].numerator)) / arb(int(I[i][j].denominator))) - (arb(int(J1[i][j].numerator)) / arb(int(J1[i][j].denominator)))
print(f'A built ({time.time()-t0:.0f}s); balancing ...', flush=True)

scale = []
for i in range(n):
    aii = A[i, i]
    if aii.lower() <= 0:
        print(f'k={k}: A[{i}][{i}] 非正 → 失败', flush=True); sys.exit(1)
    scale.append(1 / arb.sqrt(aii))
for i in range(n):
    si = scale[i]
    for j in range(n):
        A[i, j] = si * A[i, j] * scale[j]
print(f'balanced ({time.time()-t0:.0f}s); LDL^T (symmetric pivoting, arb) ...', flush=True)

D_ = [arb(0)] * n
L = [[arb(0)] * n for _ in range(n)]
t1 = time.time()
min_pivot = None
for j in range(n):
    # 候选对角 (区间中点选最大)
    best = j; best_mid = None
    for i in range(j, n):
        d = A[i, i]
        Li = L[i]
        for m in range(j):
            Lim = Li[m]
            d -= Lim * Lim * D_[m]
        midv = (d.lower() + d.upper()) / 2
        if best_mid is None or midv > best_mid:
            best = i; best_mid = midv
    if best != j:
        for t in range(n):
            A[j, t], A[best, t] = A[best, t], A[j, t]
        for t in range(n):
            A[t, j], A[t, best] = A[t, best], A[t, j]
        for t in range(j):
            L[j][t], L[best][t] = L[best][t], L[j][t]
    v = A[j, j]
    for m in range(j):
        Ljm = L[j][m]
        v -= Ljm * Ljm * D_[m]
    D_[j] = v
    if v.lower() <= 0:
        print(f'k={k}: j={j} pivot lower {v.lower()} ≤ 0 → 判定失败', flush=True)
        sys.exit(1)
    if min_pivot is None or v.lower() < min_pivot.lower():
        min_pivot = v
    L[j][j] = arb(1)
    for i in range(j + 1, n):
        s = A[i, j]
        for m in range(j):
            s -= L[i][m] * D_[m] * L[j][m]
        L[i][j] = s / v
    if j % 100 == 0:
        print(f'  j={j}/{n} min_pivot={min_pivot} ({time.time()-t1:.0f}s)', flush=True)
dt = time.time() - t1
print(f'k={k}: arb 选主元 LDL^T 完成 {dt:.0f}s, 全部主元下界 > 0', flush=True)
print(f'k={k}: 最小主元 = {min_pivot}', flush=True)
print(f'⇒ STRICT: M_{k} < 4  (arb 区间算术 + 对称选主元 + 平衡, prec={prec})', flush=True)
