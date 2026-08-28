#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_minimax_iter.py — 迭代活跃集 minimax: min_G max_{t∈T} Σ_{有效}1/G_i(t) + 惩罚
M = log G 形状 (Ns×Nx 双线性插值), 惩罚: Σ_s λ·max(0, ∫G−1)²
迭代: L-BFGS-B 优化 → 扫描连续 t 找新瓶颈 → 加入 T → 重复
"""
import numpy as np
from scipy.optimize import minimize
from numpy.polynomial.legendre import leggauss

k, eps = 49, 1/25
ONE = 1+eps
Ns, Nx = 8, 8
S_GRID = np.linspace(eps, ONE, Ns)
Y_GRID = np.linspace(0.0, 1.0, Nx)
GL_X, GL_W = leggauss(32)

def interp_vec(s_arr, y_arr, M):
    M = M.reshape(Ns, Nx)
    s_arr = np.asarray(s_arr, dtype=float); y_arr = np.asarray(y_arr, dtype=float)
    si = np.clip(np.searchsorted(S_GRID, s_arr, side='right')-1, 0, Ns-2)
    ts = (s_arr - S_GRID[si])/(S_GRID[si+1]-S_GRID[si])
    y_arr = np.clip(y_arr, 0.0, 1.0)
    yi = np.clip(np.searchsorted(Y_GRID, y_arr, side='right')-1, 0, Nx-2)
    ty = (y_arr - Y_GRID[yi])/(Y_GRID[yi+1]-Y_GRID[yi])
    return ((1-ts)*(1-ty)*M[si,yi] + (1-ts)*ty*M[si,yi+1]
            + ts*(1-ty)*M[si+1,yi] + ts*ty*M[si+1,yi+1])

def slice_penalty(M, lam):
    """Σ_s lam·max(0, ∫exp(M) dx − 1)²"""
    Ls = S_GRID + eps
    xs = Ls[:, None]*(GL_X+1)/2
    ys = xs / Ls[:, None]
    s_flat = np.repeat(S_GRID, len(GL_X))
    em = np.exp(interp_vec(s_flat, ys.flatten(), M)).reshape(Ns, len(GL_X))
    ints = np.sum(GL_W[None, :]*em, axis=1)*(Ls/2)
    viol = np.maximum(ints - 1.0, 0.0)
    return lam*np.sum(viol**2), ints

def point_contrib(m, a, b, M):
    """t = (m 个 a, k-m 个 b) 的 Σ_{有效}exp(M)"""
    u = m*a + (k-m)*b
    tot = 0.0
    s_a = 1-u+a
    if m > 0 and s_a >= eps-1e-12:
        tot += m*np.exp(interp_vec(np.array([s_a]), np.array([a/(s_a+eps)]), M))[0]
    s_b = 1-u+b
    if k-m > 0 and s_b >= eps-1e-12:
        tot += (k-m)*np.exp(interp_vec(np.array([s_b]), np.array([b/(s_b+eps)]), M))[0]
    return tot

def scan_sup(M, na=30):
    """连续扫描找 sup 点"""
    best = -1e9; arg = None
    for m in range(1, k+1):
        aa = np.linspace(1e-9, ONE/m, na)
        bb = np.linspace(0, ONE/max(1,k-m), na)
        A, B = np.meshgrid(aa, bb, indexing='ij')
        U = m*A + (k-m)*B
        ok = U <= ONE + 1e-12
        s_a = 1-U+A; s_b = 1-U+B
        tot = np.zeros(U.shape)
        va = ok & (m>0) & (s_a >= eps-1e-12)
        if va.any():
            tot[va] = m*np.exp(interp_vec(s_a[va], A[va]/(s_a[va]+eps), M))
        vb = ok & (k-m>0) & (s_b >= eps-1e-12)
        if vb.any():
            tot[vb] += (k-m)*np.exp(interp_vec(s_b[vb], B[vb]/(s_b[vb]+eps), M))
        j = np.argmax(tot)
        if tot.flat[j] > best:
            best = tot.flat[j]
            arg = (m, A.flat[j], B.flat[j])
    tot0 = k*np.exp(interp_vec(np.array([1.0]), np.array([0.0]), M))[0]
    if tot0 > best: best, arg = tot0, (0, 0.0, 0.0)
    return best, arg

if __name__ == '__main__':
    M0 = np.zeros((Ns, Nx))
    for i, s in enumerate(S_GRID):
        L = s + eps
        for j, y in enumerate(Y_GRID):
            x = y*L
            M0[i, j] = np.log((s + 48*x)*np.log((49*s + 48*eps)/s)/48)
    v0, arg0 = scan_sup(M0, na=24)
    print(f'初始(论文形): sup={v0:.6f} at m={arg0[0]} a={arg0[1]:.4f}', flush=True)
    # 活跃集
    T = [(0, 0.0, 0.0), arg0]  # t=0 + 初始瓶颈
    lam = 50.0
    for it in range(12):
        def obj(mf):
            vals = [point_contrib(m, a, b, mf) for (m, a, b) in T]
            pen, _ = slice_penalty(mf, lam)
            return max(vals) + pen
        res = minimize(obj, M0.flatten(), method='L-BFGS-B',
                       options={'maxiter': 60, 'ftol': 1e-12})
        M0 = res.x
        v, arg = scan_sup(M0, na=30)
        print(f'iter {it}: 活跃集 {len(T)} 点, sup={v:.6f} at (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})', flush=True)
        if arg not in T and len(T) < 20:
            T.append(arg)
        _, ints = slice_penalty(M0.reshape(Ns,Nx), lam)
        if it % 3 == 2:
            lam *= 2
    print(f'最终: sup={v:.6f}  {"<4!!!" if v < 4 else ""}')
