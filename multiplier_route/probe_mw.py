#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probe_mw.py — S2 数值探针: 乘子权 w = u_19 (parts>=2 Ritz 向量)
目标: M_{49,1/25} <= sup_t m_w(t), m_w(t) = [Σ_i W_i(t_{≠i})·1_{Σ_{j≠i}t_j≤1−ε}]/w(t)
  W_i(t_{≠i}) = ∫_0^{1+ε−Σ_{j≠i}t_j} w(x, t_{≠i}) dx   (论文 Theorem 3.12 的 J_{i,1−ε})
对对称 w: 所有 i 项相同 ⟹ m_w(t) = k·W_1(t_{≠1})·1_{...}/w(t)
用法: python3 probe_mw.py [n_points=200000] [sigma=0] [seed]
输出: 正性检查、sup m_w (带/不带 indicator)、达到位置、σ 修正后的结果
"""
import sys, json, math, time
import numpy as np

sys.path.insert(0, '/data4/guoshaoyang/dsh_scan2')
from frac_multi_all import gen_all_partitions, split_a

k, D, eps = 49, 19, 1.0/25.0
NPTS = int(sys.argv[1]) if len(sys.argv) > 1 else 200000
SIGMA = float(sys.argv[2]) if len(sys.argv) > 2 else 0.0
SEED = int(sys.argv[3]) if len(sys.argv) > 3 else 1
rng = np.random.default_rng(SEED)

# ---- 基 (与缓存/特征向量索引严格一致) ----
parts = gen_all_partitions(D)
basis = []
for gamma in parts:
    dg = sum(gamma)
    for r in range(0, D - dg + 1):
        basis.append((r, gamma))
n = len(basis)
print(f"basis n={n}", flush=True)

# 预计算每个基元素的 split 数据: (coef, Sa, gamma_rest) 折叠 a_j·c_a·B_a
fac = [math.factorial(m) for m in range(3*D + 2*k + 100)]
splits = {gamma: split_a(list(gamma)) for gamma in parts}

import gmpy2
from gmpy2 import mpfr, get_context
get_context().precision = 512
vd = json.load(open(f'/data4/guoshaoyang/dsh_scan2/rayleigh_vec_49_{D}_e1_25.json'))
v = [mpfr(s) for s in vd['v_scaled']]
dd = [mpfr(s) for s in vd['dd']]
a_mp = [v[i] * dd[i] for i in range(n)]
amax = max(abs(x) for x in a_mp)
a = np.array([float(x / amax) for x in a_mp], dtype=np.float64)
print(f"a[0:3] = {a[:3]}", flush=True)

# w(t) 的项: (r, gamma) -> 系数 a_j; W 的项: 折叠 splits
w_terms = []   # (a_j, r, gamma)
W_terms = []   # (coef, r+Sa+1 指数, gamma_rest)
for j, (r, gamma) in enumerate(basis):
    w_terms.append((a[j], r, gamma))
    for (c, Sa, grest) in splits[gamma]:
        Ba = fac[r] * fac[Sa] / fac[r + Sa + 1]
        W_terms.append((a[j] * c * Ba, r + Sa + 1, grest))
print(f"w_terms={len(w_terms)} W_terms={len(W_terms)}", flush=True)

# ---- 评估函数 (向量化, 批处理) ----
def eval_w_batch(T):
    """T: (B, k) 点阵 -> w(T) 向量; 同时返回 S = Σt"""
    B = T.shape[0]
    S = T.sum(axis=1)
    # 幂和 P_m, m<=D
    Pm = np.zeros((B, D + 1))
    for m in range(1, D + 1):
        Pm[:, m] = np.power(T, m).sum(axis=1)
    u = (1 + eps - S)[:, None]
    val = np.zeros(B)
    for (aj, r, gamma) in w_terms:
        term = np.power(u[:, 0], r)
        for m in gamma:
            term = term * Pm[:, m]
        val += aj * term
    return val, S, Pm

def eval_W_batch(Trest):
    """Trest: (B, k-1) 点阵 (t_{≠1}) -> W_1(Trest) 向量; 返回 L = 1+ε−Σrest"""
    B = Trest.shape[0]
    Spr = Trest.sum(axis=1)
    L = (1 + eps - Spr)[:, None]
    Pm = np.zeros((B, D + 1))
    for m in range(1, D + 1):
        Pm[:, m] = np.power(Trest, m).sum(axis=1)
    val = np.zeros(B)
    for (coef, e, grest) in W_terms:
        term = np.power(L[:, 0], e)
        for m in grest:
            term = term * Pm[:, m]
        val += coef * term
    return val, L[:, 0]

def mw_batch(T, with_ind=True):
    w, S, _ = eval_w_batch(T)
    Trest = T[:, 1:]
    W1, L = eval_W_batch(Trest)
    ind = np.ones(T.shape[0])
    if with_ind:
        ind = (Trest.sum(axis=1) <= 1 - eps).astype(float)
    m = k * W1 * ind / w
    return m, w, W1, ind

# ---- 采样: 均匀 + 边界 + 图案 + 随机 ----
t0 = time.time()
def sample_full(B):
    # 均匀 Dirichlet(1,...,1) 于 (1+eps)R_k
    u = rng.random((B, k)) + 1e-12
    t = u / u.sum(axis=1)[:, None] * (1 + eps)
    return t

B = 20000
Ts = []
# 1) 均匀采样 (含 indicator 区域)
Ts.append(sample_full(NPTS))
# 2) 边界分层: 顶点附近 & 面 Σt=1+ε 附近
nB = NPTS // 4
u = rng.random((nB, k)) + 1e-12
t = u / u.sum(axis=1)[:, None] * (1 + eps)
# 压缩到近边界: t <- (1+eps) - (1+eps-t)^1.5
t = (1 + eps) - np.power((1 + eps) - t, 1.5)
Ts.append(t)
# 3) 小坐标分层 (近 t_j=0 面)
u = rng.random((nB, k)) + 1e-12
t = u / u.sum(axis=1)[:, None] * (1 + eps)
t = np.power(t, 2.0)   # 拉向坐标轴
t = t / t.sum(axis=1)[:, None] * (1 + eps) * 0.999
Ts.append(t)
# 4) 图案族: t=(x, y,...,y) 的细网格 + 随机
xg = np.linspace(0, 1 + eps, 60)
yg = np.linspace(0, (1 + eps) / (k - 1), 60)
X, Y = np.meshgrid(xg, yg)
mask = (X + (k - 1) * Y <= 1 + eps + 1e-9)
pat = np.zeros((mask.sum(), k))
pat[:, 0] = X[mask]; pat[:, 1:] = Y[mask][:, None]
Ts.append(pat)
# 5) 两群图案: (x, y,...,y, z,...,z) 随机
nC = nB
u = rng.random((nC, 3))
s = u.sum(axis=1)
x = u[:, 0]/s*(1+eps); y = u[:, 1]/s*(1+eps); z = u[:, 2]/s*(1+eps)
n1 = rng.integers(1, k-1, nC)
pat2 = np.zeros((nC, k))
pat2[:, 0] = x
for i in range(nC):
    pat2[i, 1:1+n1[i]] = y[i]/(n1[i]) * (1 - x[i]/(1+eps))
    pat2[i, 1+n1[i]:] = z[i]/(k-1-n1[i]) * (1 - x[i]/(1+eps))
# 保证 Σt ≤ 1+eps
srow = pat2.sum(axis=1)
pat2 = pat2 * ((1 + eps) / np.maximum(srow, 1e-12))[:, None]
Ts.append(pat2)

T = np.vstack(Ts)
print(f"total points: {T.shape[0]} (build {time.time()-t0:.0f}s)", flush=True)

# ---- 正性检查 (w 和 W1) ----
best = None
def scan(T, tag):
    global best
    m, w, W1, ind = mw_batch(T)
    # 正性
    wmin, wmax = w.min(), w.max()
    if wmin < 0:
        print(f"[{tag}] w<0: min={wmin:.4e} at {T[w.argmin()]}", flush=True)
    # 只在 w>0 的点上算 m (w<=0 处 m 无意义/方向相反)
    ok = w > 0
    if ok.any():
        mok = m[ok]
        i = np.argmax(mok)
        loc = T[ok][i]
        if best is None or mok[i] > best[0]:
            best = (mok[i], tag, loc, w[ok][i], W1[ok][i], ind[ok][i])
        print(f"[{tag}] sup m_w = {mok[i]:.6f}  at {loc}  (w={w[ok][i]:.3e}, ind={ind[ok][i]})", flush=True)
    # 无 indicator 版本
    m2, _, _, _ = mw_batch(T, with_ind=False)
    ok2 = w > 0
    if ok2.any():
        i2 = np.argmax(m2[ok2])
        print(f"[{tag}] sup m_w (无 indicator) = {m2[ok2][i2]:.6f} at {T[ok2][i2]}", flush=True)
    return

# 分块扫描避免内存峰值
T = T[rng.permutation(T.shape[0])]
for s in range(0, T.shape[0], B):
    scan(T[s:s+B], f"block{s//B}")
print(f"\n===== BEST: sup m_w = {best[0]:.6f} (M尺度) at {best[1]}: {best[2]} =====", flush=True)
print(f"位置: t1={best[2][0]:.6f}, 其余和={best[2][1:].sum():.6f}, w={best[3]:.3e}, W1={best[4]:.3e}, indicator={best[5]}", flush=True)
print(f"边界检查: Σt = {best[2].sum():.6f} (1+ε={1+eps}); 若接近 1+ε → 边界极大", flush=True)
print(f"4位有效数字: sup ≈ {best[0]:.4g}", flush=True)
