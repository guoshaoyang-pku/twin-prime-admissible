#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_minimax_norm.py — 归一化内建 minimax: 1/G(x;s) = exp(M)·∫exp(-M), 自动 ∫G=1
活跃集迭代: L-BFGS-B 优化 M (Ns×Nx) → 扫描新瓶颈 → 加入 → 重复
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

def norm_factor(s, M):
    """∫_0^{s+eps} exp(-M) dx (归一化因子)"""
    L = s + eps
    xs = L*(GL_X+1)/2
    return np.sum(GL_W*np.exp(-interp_vec(np.full(len(xs), s), xs/L, M)))*L/2

def invG(s, x, M):
    """1/G(x;s) = exp(M(x))·∫exp(-M)"""
    return np.exp(interp_vec(np.array([s]), np.array([x/(s+eps)]), M))[0] * norm_factor(s, M)

def scan_sup(M, na=28):
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
            L_a = s_a[va]+eps
            nf_a = np.array([norm_factor(s, M) for s in s_a[va]])
            tot[va] = m*np.exp(interp_vec(s_a[va], A[va]/L_a, M))*nf_a
        vb = ok & (k-m>0) & (s_b >= eps-1e-12)
        if vb.any():
            L_b = s_b[vb]+eps
            nf_b = np.array([norm_factor(s, M) for s in s_b[vb]])
            tot[vb] += (k-m)*np.exp(interp_vec(s_b[vb], B[vb]/L_b, M))*nf_b
        j = np.argmax(tot)
        if tot.flat[j] > best: best, arg = tot.flat[j], (m, A.flat[j], B.flat[j])
    tot0 = k*invG(1.0, 0.0, M)
    if tot0 > best: best, arg = tot0, (0, 0.0, 0.0)
    return best, arg

def point_contrib(m, a, b, M):
    u = m*a + (k-m)*b
    tot = 0.0
    s_a = 1-u+a
    if m > 0 and s_a >= eps-1e-12: tot += m*invG(s_a, a, M)
    s_b = 1-u+b
    if k-m > 0 and s_b >= eps-1e-12: tot += (k-m)*invG(s_b, b, M)
    return tot

if __name__ == '__main__':
    M0 = np.zeros((Ns, Nx))
    for i, s in enumerate(S_GRID):
        L = s + eps
        for j, y in enumerate(Y_GRID):
            x = y*L
            M0[i, j] = np.log((s + 48*x)*np.log((49*s + 48*eps)/s)/48)
    v0, arg0 = scan_sup(M0, na=24)
    print(f'初始(论文形): sup={v0:.6f} at m={arg0[0]} a={arg0[1]:.4f}', flush=True)
    T = [(0, 0.0, 0.0), arg0]
    for it in range(14):
        def obj(mf):
            vals = [point_contrib(m, a, b, mf) for (m, a, b) in T]
            return max(vals)
        res = minimize(obj, M0.flatten(), method='L-BFGS-B', options={'maxiter': 80, 'ftol': 1e-12})
        M0 = res.x
        v, arg = scan_sup(M0, na=28)
        print(f'iter {it}: 活跃集 {len(T)} 点, sup={v:.6f} at (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})', flush=True)
        if all(arg != t for t in T) and len(T) < 24:
            T.append(arg)
    print(f'最终: sup={v:.6f}  {"<4!!!" if v < 4 else ""}')
