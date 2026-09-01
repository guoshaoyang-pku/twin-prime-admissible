#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""lp_multiplier.py — S3c 半无限 LP: 求乘子权 w (平衡基) 使 sup m_w <= lambda*
约束 (论文 Theorem 3.12, 精确): 对所有采样点 t:
  F(t) := Σ_{i: t_i >= 2ε−d(t)} W_i(t_{≠i})  <=  lambda* · w(t),   d(t)=1+ε−Σt
  w(t) >= delta; 归一化 w(t0)=1
变量: 平衡基系数 c~ (w = Σ c~_j · dd_j·b_j)
用法: python3 lp_multiplier.py <lambda_star> [n_pts_per_family] [out.json]
"""
import sys, json, math, time, pickle
import numpy as np

sys.path.insert(0, '/data4/guoshaoyang/dsh_scan2')
from frac_multi_all import gen_all_partitions, split_a
import gmpy2
from gmpy2 import mpfr, get_context
get_context().precision = 256

k, D, eps = 49, 19, 1.0/25.0
LAM = float(sys.argv[1]) if len(sys.argv) > 1 else 3.999
NPF = int(sys.argv[2]) if len(sys.argv) > 2 else 600
OUT = sys.argv[3] if len(sys.argv) > 3 else f'lp_result_{LAM}.json'
rng = np.random.default_rng(42)

parts = gen_all_partitions(D)
basis = []
for gamma in parts:
    dg = sum(gamma)
    for r in range(0, D - dg + 1):
        basis.append((r, gamma))
n = len(basis)

vd = json.load(open(f'/data4/guoshaoyang/dsh_scan2/rayleigh_vec_49_{D}_e1_25.json'))
v = [mpfr(s) for s in vd['v_scaled']]
dd = [mpfr(s) for s in vd['dd']]
ddF = np.array([float(x) for x in dd], dtype=np.float64)
fac = [math.factorial(m) for m in range(3*D + 2*k + 100)]
splits = {gamma: split_a(list(gamma)) for gamma in parts}
# W 项预计算 (平衡基): 每个基元素 j 的 splits 折叠: (coef', r+Sa+1, grest), coef'=dd_j·c·Ba
W_terms = []   # per basis j: list of (coef, e, grest)
for j, (r, gamma) in enumerate(basis):
    ts = []
    for (c, Sa, grest) in splits[gamma]:
        Ba = fac[r]*fac[Sa]/fac[r+Sa+1]
        ts.append((c*Ba, r+Sa+1, grest))
    W_terms.append(ts)

# ---- 基函数与 W 的批量评估 (float64, 平衡基) ----
def eval_mat(T):
    """T:(B,k) -> (B,n) 矩阵 M[l,j]=b~_j(t^l) = dd_j·(1+eps-S)^r·p_gamma"""
    B = T.shape[0]
    S = T.sum(1)
    Pm = np.zeros((B, D+1))
    for m in range(1, D+1):
        Pm[:, m] = np.power(T, m).sum(1)
    u = (1+eps-S)[:, None]
    M = np.zeros((B, n))
    for j, (r, gamma) in enumerate(basis):
        term = np.power(u[:, 0], r)
        for m in gamma:
            term = term * Pm[:, m]
        M[:, j] = term
    return M, S

def eval_Wmat(Trest):
    """Trest:(B,k-1) -> (B,n) 矩阵 Wmat[l,j]=W~_1^{(j)}(trest) = dd_j·∫_0^L b_j"""
    B = Trest.shape[0]
    Spr = Trest.sum(1)
    L = (1+eps-Spr)[:, None]
    Pm = np.zeros((B, D+1))
    for m in range(1, D+1):
        Pm[:, m] = np.power(Trest, m).sum(1)
    Wm = np.zeros((B, n))
    for j in range(n):
        col = np.zeros(B)
        for (coef, e, grest) in W_terms[j]:
            term = np.power(L[:, 0], e)
            for m in grest:
                term = term * Pm[:, m]
            col += coef*term
        Wm[:, j] = col
    return Wm

# ---- 采样点 ----
def sample_full(B):
    u = rng.random((B, k)) + 1e-12
    return u / u.sum(1)[:, None] * (1+eps)

Ts = []
Ts.append(sample_full(NPF))                                   # 均匀
u = rng.random((NPF, k)) + 1e-12
t = u / u.sum(1)[:, None]
Ts.append(t * (1-eps) * 0.999)                                # 全 active 区域
# 超平面邻域: 固定 t_{≠i} 接近 (1-eps) 边界
u = rng.random((NPF, k-1)) + 1e-12
tre = u / u.sum(1)[:, None] * (1-eps) * (1 + 0.02*rng.standard_normal((NPF,1)))
tre = np.clip(tre, 0, None)
t = np.zeros((NPF, k))
t[:, 1:] = tre
t[:, 0] = rng.random(NPF)*(1+eps-tre.sum(1))
Ts.append(t)                                                  # 近超平面 (i=1 active 边界)
# 边界面 Σt=1+eps
u = rng.random((NPF, k)) + 1e-12
t = u / u.sum(1)[:, None] * (1+eps)
t = t / t.sum(1)[:, None] * (1+eps)
Ts.append(t)
# 边界角区 (全 t_i < 2eps, Σt=1+eps)
u = rng.random((NPF, k))
t = u / u.sum(1)[:, None] * (2*eps) * 0.98
Ts.append(t)
# 两群图案
u = rng.random((NPF, 3))
x = u[:, 0]/u.sum(1)*(1+eps); y = u[:, 1]/u.sum(1)*(1+eps); z = u[:, 2]/u.sum(1)*(1+eps)
n1 = rng.integers(1, k-1, NPF)
t = np.zeros((NPF, k)); t[:, 0] = x
for i in range(NPF):
    t[i, 1:1+n1[i]] = y[i]/max(n1[i],1)
    t[i, 1+n1[i]:] = z[i]/max(k-1-n1[i],1)
srow = t.sum(1)
t = t * ((1+eps)/np.maximum(srow, 1e-12))[:, None]
Ts.append(t)
T = np.vstack(Ts)
B = T.shape[0]
print(f"points: {B}, n_vars: {n}", flush=True)

t0 = time.time()
M, S = eval_mat(T)          # (B, n)  w 系数矩阵
Trest = T[:, 1:]
Wm = eval_Wmat(Trest)       # (B, n)  W_1 系数矩阵
print(f"matrices built ({time.time()-t0:.0f}s)", flush=True)

# active 集: 对 i=1..k: active ⟺ Σ_{j≠i}t_j <= 1-eps ⟺ t_i >= S - (1-eps)
th = S - (1-eps)            # (B,)
# F = Σ_{i active} W_i; W_i(t_{≠i}) = W_1(permuted) — 对称 w ⟹ W_i = W_1 同一函数
# 计算每个点的 active 数 c_active 与 ΣW(t_{≠i}): 对每个 i 需要 W 在去掉 t_i 的点上
Fmat = np.zeros((B, n))
act_cnt = np.zeros(B, dtype=int)
for i in range(k):
    Ti = np.delete(T, i, axis=1)          # (B, k-1)
    Wi = eval_Wmat(Ti)                    # (B, n)
    active = (T[:, i] >= th).astype(float)
    Fmat += Wi * active[:, None]
    act_cnt += active.astype(int)
print(f"F built ({time.time()-t0:.0f}s), active 分布: min={act_cnt.min()} max={act_cnt.max()}", flush=True)

# ---- LP: min ‖c‖₁ (c⁺/c⁻ 分裂)  s.t. F - LAM*w <= 0, -w <= -delta, w <= CAP, w(t0)=1 ----
DELTA = 1e-6
CAP = 1000.0
# 变量: [c⁺(n), c⁻(n)]  w = (c⁺-c⁻)·b
A1 = np.hstack([Fmat - LAM*M, -(Fmat - LAM*M)])          # F - LAM*w <= 0
A2 = np.hstack([-M, M])                                   # -w <= -delta
A3 = np.hstack([M, -M])                                   # w <= CAP
A_ub = np.vstack([A1, A2, A3])
b_ub = np.concatenate([np.zeros(B), -DELTA*np.ones(B), CAP*np.ones(B)])
t0_pt = np.full(k, 0.5/k)
M0, _ = eval_mat(t0_pt.reshape(1, -1))
A_eq = np.hstack([M0[0], -M0[0]])                          # w(t0)=1
b_eq = np.array([1.0])
print(f"LP: {2*n} vars, {len(b_ub)} ineq, 1 eq ({time.time()-t0:.0f}s)", flush=True)

from scipy.optimize import linprog
t1 = time.time()
obj = np.ones(2*n)                                         # min ‖c‖₁ = Σ(c⁺+c⁻)
res = linprog(obj, A_ub=A_ub, b_ub=b_ub, A_eq=A_eq.reshape(1,-1), b_eq=b_eq,
              bounds=[(0, None)]*(2*n), method='highs')
print(f"LP solved ({time.time()-t1:.0f}s): status={res.status} {res.message}", flush=True)
if res.status == 0:
    cp = res.x[:n]; cm = res.x[n:]
    c = cp - cm
    print(f"‖c‖₁ = {np.abs(c).sum():.3e}", flush=True)
    # 验证: 密集采样
    NB = 8000
    Tv = sample_full(NB)
    Mv, Sv = eval_mat(Tv)
    thv = Sv - (1-eps)
    Fv = np.zeros(NB)
    for i in range(k):
        Ti = np.delete(Tv, i, axis=1)
        Wi = eval_Wmat(Ti) @ c
        Fv += Wi * (Tv[:, i] >= thv)
    wv = Mv @ c
    ratio = Fv/wv
    viol = ratio[ratio > LAM]
    print(f"验证: max m_w = {ratio.max():.6f} (λ*={LAM}), 违例点数 = {len(viol)}, "
          f"max 违例 = {ratio.max()-LAM:.6f}", flush=True)
    wmin = wv.min()
    print(f"验证: min w = {wmin:.4e} (δ={DELTA})", flush=True)
    json.dump({'lam': LAM, 'status': res.status, 'c': c.tolist(),
               'max_mw': float(ratio.max()), 'wmin': float(wmin)}, open(OUT, 'w'))
    print(f"saved {OUT}", flush=True)
else:
    print(f"INFEASIBLE at λ*={LAM} (status {res.status})", flush=True)
