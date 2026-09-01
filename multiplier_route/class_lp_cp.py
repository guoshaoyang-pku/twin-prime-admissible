#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""class_lp_cp.py — 切割平面版类-LP (半无限逼近)
循环: 采样点集上解 LP (min ‖c‖₁, 约束 F<=λ*w, w>=δ, w(t0)=1)
      → 结构化+随机密集验证 → 加入最坏违例点 → 重解
用法: python3 class_lp_cp.py [lambda] [deg] [max_iters]
"""
import sys, json, math, time
import numpy as np

sys.path.insert(0, '/data4/guoshaoyang/dsh_scan2')
from frac_multi_all import gen_all_partitions, split_a

k, eps = 49, 1/25
E = 1+eps
LAM = float(sys.argv[1]) if len(sys.argv) > 1 else 3.999
DEG = int(sys.argv[2]) if len(sys.argv) > 2 else 5
MAXIT = int(sys.argv[3]) if len(sys.argv) > 3 else 3
rng = np.random.default_rng(21)

parts = gen_all_partitions(DEG)
basis = []
for gamma in parts:
    dg = sum(gamma)
    for r in range(0, DEG - dg + 1):
        basis.append((r, gamma))
nb = len(basis)
splits = {gamma: split_a(list(gamma)) for gamma in parts}
print(f"degree-{DEG} basis: {nb}", flush=True)

def seg_integral(a, b, L, r, gamma, P):
    tot = 0.0
    for (c, Sa, grest) in splits[gamma]:
        intv = 0.0
        for m in range(r+1):
            val = (b**(Sa+m+1) - a**(Sa+m+1))/(Sa+m+1)
            intv += math.comb(r, m) * (L**(r-m)) * ((-1)**m) * val
        term = c * intv
        for mm in grest:
            term *= P[mm]
        tot += term
    return tot

def eval_basis(t):
    S = sum(t)
    P = {m: sum(x**m for x in t) for m in range(1, DEG+1)}
    u = E - S
    vals = np.zeros(nb)
    for j, (r, gamma) in enumerate(basis):
        term = u**r
        for m in gamma:
            term *= P[m]
        vals[j] = term
    return vals

def W_class_contribs(trest):
    S1 = sum(trest); L = E - S1
    P = {m: sum(x**m for x in trest) for m in range(1, DEG+1)}
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
        jcls = min(1 + sum(1 for tv in trest if tv >= xmid + th0), k)
        vec = np.zeros(nb)
        for jb, (r, gamma) in enumerate(basis):
            vec[jb] = seg_integral(a, b, L, r, gamma, P)
        segs.append((jcls, vec))
    return segs

def row_of(t):
    """返回 (Frow, wrow) — F 与 w 的系数向量"""
    S = t.sum(); th = S - (1-eps)
    jm = int((t >= th).sum())
    wrow = np.zeros((k+1)*nb)
    wrow[jm*nb:(jm+1)*nb] = eval_basis(t)
    Frow = np.zeros((k+1)*nb)
    for i in range(k):
        if t[i] < th - 1e-12:
            continue
        trest = np.delete(t, i)
        for (jcls, vec) in W_class_contribs(trest):
            Frow[jcls*nb:(jcls+1)*nb] += vec
    return Frow, wrow

def solve_lp(Ts):
    B = len(Ts)
    A_ub = np.zeros((B, NV))
    for m in range(B):
        Fr, wr = row_of(Ts[m])
        A_ub[m, :] = Fr - LAM*wr
    A_pos = np.zeros((B, NV))
    for m in range(B):
        S = Ts[m].sum(); th = S - (1-eps)
        jm = int((Ts[m] >= th).sum())
        A_pos[m, jm*nb:(jm+1)*nb] = -eval_basis(Ts[m])
    A_ub = np.vstack([A_ub, A_pos])
    b_ub = np.concatenate([np.zeros(B), -1e-6*np.ones(B)])
    t0_pt = np.full(k, 0.5/k)
    A_eq = np.zeros(NV); A_eq[49*nb:(49+1)*nb] = eval_basis(t0_pt)
    from scipy.optimize import linprog
    A2 = np.hstack([A_ub, -A_ub])
    A2eq = np.hstack([A_eq, -A_eq])
    res = linprog(np.ones(2*NV), A_ub=A2, b_ub=b_ub, A_eq=A2eq.reshape(1,-1), b_eq=np.array([1.0]),
                  bounds=[(0, None)]*(2*NV), method='highs')
    if res.status != 0:
        return None, res.status
    cp = res.x[:NV]; cm = res.x[NV:]
    return cp - cm, 0

def verify(Ts_v, c):
    worst = []
    maxr = 0
    for m in range(len(Ts_v)):
        t = Ts_v[m]
        Fr, wr = row_of(t)
        wv = np.dot(wr, c)
        Fv = np.dot(Fr, c)
        if wv > 0:
            r = Fv/wv
            if r > maxr:
                maxr = r
            if r > LAM:
                worst.append((r, t))
        elif wv < 0:
            worst.append((1e9, t))
    return maxr, worst

# 采样族
def sample_class(j, N):
    out = []
    while len(out) < N:
        u = rng.random(k) + 1e-12
        t = u / u.sum() * E * rng.random()
        S = t.sum(); th = S - (1-eps)
        if int((t >= th).sum()) == j:
            out.append(t)
    return out

def sample_structured(N):
    out = []
    # 图案: 全等, 单点, 两点, 混合, 面, 角
    for u in np.linspace(0.002, E-0.002, N//6):
        C = E - u
        out.append(np.full(k, C/k))
        out.append(np.array([C] + [0.0]*(k-1)))
        out.append(np.array([C/2]*2 + [0.0]*(k-2)))
        x = rng.random()*C
        y = (C-x)/(k-1)
        out.append(np.array([x] + [y]*(k-1)))
    # 随机
    for _ in range(N):
        u = rng.random(k) + 1e-12
        out.append(u / u.sum() * E)
    # 面
    for _ in range(N//4):
        u = rng.random(k) + 1e-12
        t = u / u.sum() * E
        t = t / t.sum() * E
        out.append(t)
    return out

NV = (k+1)*nb
Ts = []
for j in range(k+1):
    Ts += sample_class(j, 60)
print(f"initial samples: {len(Ts)}", flush=True)

t0 = time.time()
c = None
for it in range(MAXIT):
    t1 = time.time()
    c, st = solve_lp(Ts)
    print(f"iter {it}: LP status={st} ({time.time()-t1:.0f}s)", flush=True)
    if c is None:
        print("LP INFEASIBLE — abort", flush=True)
        break
    print(f"  ‖c‖₁ = {np.abs(c).sum():.3e}", flush=True)
    Tv = sample_structured(3000)
    maxr, worst = verify(Tv, c)
    print(f"  verify: max m_w = {maxr:.6f}, 违例数 = {len(worst)} ({time.time()-t0:.0f}s)", flush=True)
    if len(worst) == 0:
        print(f"  ✓ 无违例 at λ*={LAM}", flush=True)
        break
    worst.sort(key=lambda x: -x[0])
    add = [t for _, t in worst[:300]]
    # 违例点邻域扰动
    for _, t in worst[:100]:
        add.append(np.clip(t + 0.002*rng.standard_normal(k), 0, None))
    Ts = list(Ts) + add
    print(f"  added {len(add)} points, total {len(Ts)}", flush=True)

if c is not None:
    # 最终验证: 30k 点
    Tv = sample_structured(20000)
    maxr, worst = verify(Tv, c)
    print(f"FINAL verify: max m_w = {maxr:.6f}, 违例 = {len(worst)} ({time.time()-t0:.0f}s)", flush=True)
    json.dump({'lam': LAM, 'deg': DEG, 'c': c.tolist(), 'max_mw': float(maxr),
               'nviol': len(worst)}, open(f'class_lp_cp_{LAM}.json', 'w'))
    print("saved", flush=True)
