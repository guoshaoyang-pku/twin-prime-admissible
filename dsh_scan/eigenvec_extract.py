#!/usr/bin/env python3
"""eigenvec_extract.py — 提取 λ_max 特征向量 (原基系数 v) + F(t) 评估 + 符号检查
F(t) = sum_i v_i * (1+eps-P1)^r * p_gamma(t)   (论文基 {(1+eps-P1)^r p_gamma})
p_gamma: 生成函数 DP 评估 (不同 index 约束)
用法: python3 eigenvec_extract.py k D eps_num eps_den [cache]
"""
import sys, time, pickle
import numpy as np
sys.path.insert(0, '.')
import legendre_fix as lf

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
cache = sys.argv[5] if len(sys.argv) > 5 else f'frac_cache_{k}_{D}.pkl'

with open(cache, 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
print(f'k={k} D={D} n={n}', flush=True)

# 基: 与 frac_multi 相同
def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

parts_all = gen_even_partitions(D)
basis = []
for gamma in parts_all:
    for r in range(0, D - sum(gamma) + 1):
        basis.append((r, gamma))
assert len(basis) == n, f'basis {len(basis)} != n {n}'

t0 = time.time()
Jt, s, L, d = lf.reduce_pair(I, J1, 512)
print(f'reduce {time.time()-t0:.0f}s', flush=True)
Jtf = np.array([[float(x) for x in row] for row in Jt])
lam = float(np.linalg.eigvalsh(Jtf)[-1])
w = np.linalg.eigh(Jtf)[1][:, -1]
# v = L^{-T} (s*w): 解 L^T z = s*w
b = np.array([float(s[i]) * w[i] for i in range(n)])
Lnp = np.array([[float(L[i][j]) if j < i else (1.0 if i == j else 0.0) for j in range(n)] for i in range(n)])
z = np.linalg.solve(Lnp.T, b)
v = z / np.sqrt(np.dot(z, np.dot(np.array([[float(x) for x in row] for row in I]), z)))
np.save(f'ev_k{k}_d{D}_eps{en}_{ed}.npy', v)
print(f'λ_max = {lam:.15f}  M = {k*lam:.9f}  v 保存 (L2 范数: {np.linalg.norm(v):.4f})', flush=True)
print('v 符号: 正', (v > 0).sum(), '/', n, ' 负', (v < 0).sum(), ' 零', (v == 0).sum())
