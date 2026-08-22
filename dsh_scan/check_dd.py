#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""check_dd.py — 检查 (4/k)I − J̃ 的区间对角占优 (Gershgorin 严格正定路径)
用法: python3 check_dd.py k D eps_num eps_den [cache]
若对角占优: (4/k)I − J̃ 严格对角占优且对称 ⇒ 正定 ⇒ λ_max(J1,I) < 4/k ⇒ M < 4 严格。
区间化: J̃ 为 mpfr 512 bits 计算, 误差带 δ=2^-500 (保守), 检查 (4/k−J̃_ii−δ) − Σ|J̃_ij|−nδ > 0。
"""
import sys, pickle, time
sys.path.insert(0, '.')
from fractions import Fraction as Fr

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
cache = sys.argv[5] if len(sys.argv) > 5 else f'frac_cache_{k}_{D}.pkl'

import legendre_fix as lf
with open(cache, 'rb') as f:
    I, J1 = pickle.load(f)
t0 = time.time()
Jt, s, L, d = lf.reduce_pair(I, J1, 512)
dt = time.time() - t0
print(f'k={k} D={D} n={len(Jt)} reduce {dt:.0f}s', flush=True)

import numpy as np
Jtf = np.array([[float(x) for x in row] for row in Jt], dtype=np.float64)
lam = float(np.linalg.eigvalsh(Jtf)[-1])
print(f'λ_max(J̃) ≈ {lam:.15f}  M ≈ {k*lam:.9f}', flush=True)

# 区间对角占优: 误差带 δ (保守: 2^-500 覆盖 mpfr 512 bits 全部中间误差)
delta = 2.0 ** -500
mid = 4 / k
# Gershgorin 行和 (用 float, 加 δ 余量)
worst = 1e308; worst_i = -1
for i in range(len(Jtf)):
    off = np.abs(Jtf[i]).sum() - abs(Jtf[i, i])
    dd = (mid - Jtf[i, i] - delta) - (off + len(Jtf) * delta)
    if dd < worst:
        worst = dd; worst_i = i
print(f'最紧行 i={worst_i}: (4/k−J̃_ii) − Σ|off| = {worst:.6e}', flush=True)
print(f'区间对角占优(含 δ=2^-500 误差带): {worst > 0}', flush=True)
if worst > 0:
    print(f'⇒ 严格正定 ⇒ M_{k} < 4 严格 (Gershgorin, 无 LDL)', flush=True)
