#!/usr/bin/env python3
"""f_eval.py — F(t) 评估 + 符号检查 + CS 上界 (特征函数方法)
F(t) = sum_i v_i (1+eps-P1)^r p_gamma(t), p_gamma 生成函数 DP
若 F > 0: G_i = F/int F dt_i 合法, 上界 = sup_t sum_i int F dt_i / F(t)
"""
import numpy as np, sys, pickle

k = int(sys.argv[1]); D = int(sys.argv[2])
en, ed = int(sys.argv[3]), int(sys.argv[4])
cache = sys.argv[5] if len(sys.argv) > 5 else f'frac_cache_{k}_{D}.pkl'
eps = en / ed

v = np.load(f'ev_k{k}_d{D}_eps{en}_{ed}.npy')
n = len(v)

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for x in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + x, parts + [x])
    rec(0, [])
    return res

parts_all = gen_even_partitions(D)
basis = []
for gamma in parts_all:
    for r in range(0, D - sum(gamma) + 1):
        basis.append((r, gamma))
assert len(basis) == n

# 分组: gamma -> (霍纳系数数组 over r)
gamma_coeffs = {}
for (r, gamma), vi in zip(basis, v):
    gamma_coeffs.setdefault(gamma, [0.0] * (D - sum(gamma) + 1))
for (r, gamma), vi in zip(basis, v):
    gamma_coeffs[gamma][r] += vi

def p_gamma(t, gamma):
    """幂和对称多项式: 生成函数 DP"""
    m = len(gamma)
    if m == 0:
        return 1.0
    size = 1 << m
    state = np.zeros(size)
    state[0] = 1.0
    for ti in t:
        if ti <= 0:
            continue
        pw = np.array([ti ** g for g in gamma])
        new = state.copy()
        for j in range(m):
            # 从不含 j 的状态转移
            src = state.copy()
            # 只从不含 j 的状态: state[S] where S & (1<<j) == 0
            mask = ~(1 << j)
            idx = np.where((np.arange(size) & (1 << j)) == 0)[0]
            new[idx | (1 << j)] += state[idx] * pw[j]
        state = new
    return state[-1]

def F(t):
    P1 = t.sum()
    u = 1 + eps - P1
    if u <= 0:
        return 0.0
    tot = 0.0
    for gamma, coeffs in gamma_coeffs.items():
        pg = p_gamma(t, gamma)
        if pg == 0:
            continue
        # 霍纳: sum_r coeffs[r] * u^r
        val = 0.0
        for c in reversed(coeffs):
            val = val * u + c
        tot += pg * val
    return tot

rng = np.random.default_rng(0)
nneg = 0; npos = 0; samples = []
for it in range(300):
    u = rng.dirichlet(np.ones(k)) * (1 + eps)
    samples.append(u)
    fv = F(u)
    if fv < 0: nneg += 1
    elif fv > 0: npos += 1
print(f'F 符号检查 (300 随机点): 正 {npos}, 负 {nneg}, 零 {300-npos-nneg}')
if nneg > 0:
    print('F 有负区域 — 特征函数不正 (需处理)')
else:
    print('F 在采样点全正 — 检查上界...')
