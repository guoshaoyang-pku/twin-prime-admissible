#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""class_lp.py — 分段对称单权乘子: w(t) = w_j(t) on {|A(t)|=j}
约束: F(t) = Σ_{i∈A(t)} W_i(t_{≠i}) <= λ*·w(t), W_i = 线段按类拆分的积分
用法: python3 class_lp.py [lambda] [n_pts_per_class] [deg] [out.json]
"""
import sys, json, math, time
import numpy as np

sys.path.insert(0, '/data4/guoshaoyang/dsh_scan2')
from frac_multi_all import gen_all_partitions, split_a

k, eps = 49, 1/25
E = 1+eps
LAM = float(sys.argv[1]) if len(sys.argv) > 1 else 3.999
NPC = int(sys.argv[2]) if len(sys.argv) > 2 else 120
DEG = int(sys.argv[3]) if len(sys.argv) > 3 else 5
OUT = sys.argv[4] if len(sys.argv) > 4 else f'class_lp_{LAM}.json'
rng = np.random.default_rng(11)

parts = gen_all_partitions(DEG)
basis = []
for gamma in parts:
    dg = sum(gamma)
    for r in range(0, DEG - dg + 1):
        basis.append((r, gamma))
nb = len(basis)
fac = [math.factorial(m) for m in range(3*DEG + 2*k + 100)]
splits = {gamma: split_a(list(gamma)) for gamma in parts}
print(f"degree-{DEG} basis: {nb} functions", flush=True)

def seg_integral(a, b, L, r, gamma, P):
    tot = 0.0
    for (c, Sa, grest) in splits[gamma]:
        intv = 0.0
        for m in range(r+1):
            cm = math.comb(r, m)
            val = (b**(Sa+m+1) - a**(Sa+m+1))/(Sa+m+1)
            intv += cm * (L**(r-m)) * ((-1)**m) * val
        term = c * intv
        for mm in grest:
            term *= P[mm]
        tot += term
    return tot

def eval_basis(t):
    S = sum(t)
    P = {}
    for m in range(1, DEG+1):
        P[m] = sum(x**m for x in t)
    u = E - S
    vals = np.zeros(nb)
    for j, (r, gamma) in enumerate(basis):
        term = u**r
        for m in gamma:
            term *= P[m]
        vals[j] = term
    return vals

def W_class_contribs(trest):
    S1 = sum(trest)
    L = E - S1
    P = {}
    for m in range(1, DEG+1):
        P[m] = sum(x**m for x in trest)
    th0 = S1 - (1-eps)
    bounds = [0.0, L]
    for tv in trest:
        xb = tv - th0
        if 1e-14 < xb < L - 1e-14:
            bounds.append(xb)
    bounds = sorted(bounds)
    segs = []
    for s in range(len(bounds)-1):
        a, b = bounds[s], bounds[s+1]
        if b - a < 1e-14:
            continue
        xmid = (a+b)/2
        jcls = 1 + sum(1 for tv in trest if tv >= xmid + th0)
        jcls = min(jcls, k)
        vec = np.zeros(nb)
        for jb, (r, gamma) in enumerate(basis):
            vec[jb] = seg_integral(a, b, L, r, gamma, P)
        segs.append((jcls, vec))
    return segs

# ---- 采样 (每类 NPC 点) ----
Ts = []; Jcls = []
for j in range(k+1):
    got = 0
    while got < NPC:
        u = rng.random(k) + 1e-12
        t = u / u.sum() * E * rng.random()
        S = t.sum()
        th = S - (1-eps)
        jj = int((t >= th).sum())
        if jj == j:
            Ts.append(t); Jcls.append(j); got += 1
    print(f"class {j}: {got} pts", flush=True)
T = np.array(Ts)
B = T.shape[0]
print(f"total pts: {B}", flush=True)

# ---- 约束行: F − LAM·w <= 0 ----
NV = (k+1)*nb
t0 = time.time()
A_ub = np.zeros((B, NV))
for m in range(B):
    t = T[m]
    jm = Jcls[m]
    wrow = np.zeros(NV)
    wrow[jm*nb:(jm+1)*nb] = eval_basis(t)
    S = t.sum(); th = S - (1-eps)
    for i in range(k):
        if t[i] < th - 1e-12:
            continue
        trest = np.delete(t, i)
        for (jcls, vec) in W_class_contribs(trest):
            wrow[jcls*nb:(jcls+1)*nb] += vec
    A_ub[m, :] = wrow - LAM*(np.zeros(NV))
    # 注意: wrow 现在 = F + w 的系数混合; 需分开
    # 重算: 分开累积
    A_ub[m, :] = 0.0
    # w 系数 (类 jm)
    A_ub[m, jm*nb:(jm+1)*nb] = eval_basis(t)
    # F 系数
    for i in range(k):
        if t[i] < th - 1e-12:
            continue
        trest = np.delete(t, i)
        for (jcls, vec) in W_class_contribs(trest):
            A_ub[m, jcls*nb:(jcls+1)*nb] += vec
    A_ub[m, :] = A_ub[m, :] - LAM*(A_ub[m, :]*0 + 0)
    # 重新正确构造: Frow − LAM·wrow
    wrow2 = np.zeros(NV); wrow2[jm*nb:(jm+1)*nb] = eval_basis(t)
    Frow = np.zeros(NV)
    for i in range(k):
        if t[i] < th - 1e-12:
            continue
        trest = np.delete(t, i)
        for (jcls, vec) in W_class_contribs(trest):
            Frow[jcls*nb:(jcls+1)*nb] += vec
    A_ub[m, :] = Frow - LAM*wrow2
print(f"constraint rows built ({time.time()-t0:.0f}s)", flush=True)

# 正性 + 归一化
DELTA = 1e-6
A_pos = np.zeros((B, NV))
for m in range(B):
    jm = Jcls[m]
    A_pos[m, jm*nb:(jm+1)*nb] = -eval_basis(T[m])
A_ub = np.vstack([A_ub, A_pos])
b_ub = np.concatenate([np.zeros(B), -DELTA*np.ones(B)])
# 归一化: w(t0)=1, t0 = 深内部 (类 49)
t0_pt = np.full(k, 0.5/k)
A_eq = np.zeros(NV); A_eq[49*nb:(49+1)*nb] = eval_basis(t0_pt)
b_eq = np.array([1.0])
print(f"LP: {NV} vars, {len(b_ub)} ineq ({time.time()-t0:.0f}s)", flush=True)

from scipy.optimize import linprog
t1 = time.time()
# c⁺/c⁻ 分裂 L1
A_ub2 = np.hstack([A_ub, -A_ub])
A_eq2 = np.hstack([A_eq, -A_eq])
res = linprog(np.ones(2*NV), A_ub=A_ub2, b_ub=b_ub, A_eq=A_eq2.reshape(1,-1), b_eq=b_eq,
              bounds=[(0, None)]*(2*NV), method='highs')
print(f"LP solved ({time.time()-t1:.0f}s): status={res.status} {res.message}", flush=True)
if res.status == 0:
    cp = res.x[:NV]; cm = res.x[NV:]
    c = cp - cm
    print(f"‖c‖₁ = {np.abs(c).sum():.3e}", flush=True)
    # 验证: 密集采样 m_w
    NB = 3000
    Ts2 = []
    for _ in range(NB):
        u = rng.random(k) + 1e-12
        t = u / u.sum() * E
        Ts2.append(t)
    T2 = np.array(Ts2)
    maxr = 0; minw = 1e9
    for m in range(NB):
        t = T2[m]
        S = t.sum(); th = S - (1-eps)
        jm = int((t >= th).sum())
        wv = np.dot(eval_basis(t), c[jm*nb:(jm+1)*nb])
        Fv = 0.0
        for i in range(k):
            if t[i] < th - 1e-12:
                continue
            trest = np.delete(t, i)
            for (jcls, vec) in W_class_contribs(trest):
                Fv += np.dot(vec, c[jcls*nb:(jcls+1)*nb])
        minw = min(minw, wv)
        if wv > 0:
            maxr = max(maxr, Fv/wv)
        if m % 5000 == 4999:
            print(f"  verify {m+1}/{NB}: max m_w so far {maxr:.4f}", flush=True)
    print(f"验证: max m_w = {maxr:.6f} (λ*={LAM}), min w = {minw:.3e}", flush=True)
    json.dump({'lam': LAM, 'status': res.status, 'c': c.tolist(),
               'max_mw': float(maxr), 'minw': float(minw)}, open(OUT, 'w'))
    print(f"saved {OUT}", flush=True)
else:
    print(f"INFEASIBLE at λ*={LAM} (status {res.status})", flush=True)
