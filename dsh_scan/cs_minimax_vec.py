#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_minimax_vec.py — 向量化修复版 CS minimax (SLSQP, 约束 ∫G≤1)"""
import numpy as np
from scipy.optimize import minimize
from numpy.polynomial.legendre import leggauss

k, eps = 49, 1/25
ONE = 1+eps
Ns, Nx = 8, 8
S_GRID = np.linspace(eps, ONE, Ns)
Y_GRID = np.linspace(0.0, 1.0, Nx)
GL_X, GL_W = leggauss(40)

def interp_vec(s_arr, y_arr, M):
    """向量化双线性插值"""
    s_arr = np.asarray(s_arr, dtype=float)
    y_arr = np.asarray(y_arr, dtype=float)
    si = np.clip(np.searchsorted(S_GRID, s_arr, side='right')-1, 0, Ns-2)
    ts = (s_arr - S_GRID[si])/(S_GRID[si+1]-S_GRID[si])
    y_arr = np.clip(y_arr, 0.0, 1.0)
    yi = np.clip(np.searchsorted(Y_GRID, y_arr, side='right')-1, 0, Nx-2)
    ty = (y_arr - Y_GRID[yi])/(Y_GRID[yi+1]-Y_GRID[yi])
    return ((1-ts)*(1-ty)*M[si,yi] + (1-ts)*ty*M[si,yi+1]
            + ts*(1-ty)*M[si+1,yi] + ts*ty*M[si+1,yi+1])

def sup_scan(M, na=28):
    best = -1e9; arg = None
    for m in range(1, k+1):
        aa = np.linspace(1e-9, ONE/m, na)
        bb = np.linspace(0, ONE/max(1,k-m), na)
        A, B = np.meshgrid(aa, bb, indexing='ij')
        U = m*A + (k-m)*B
        ok = U <= ONE + 1e-12
        s_a = 1-U+A; s_b = 1-U+B
        tot = np.full(U.shape, -1e9)
        va = ok & (m>0) & (s_a >= eps-1e-12)
        if va.any():
            tot[va] = m*np.exp(interp_vec(s_a[va], A[va]/(s_a[va]+eps), M))
        vb = ok & (k-m>0) & (s_b >= eps-1e-12)
        if vb.any():
            add = (k-m)*np.exp(interp_vec(s_b[vb], B[vb]/(s_b[vb]+eps), M))
            tot[vb] = np.where(tot[vb] > -1e8, tot[vb]+add, add)
        j = np.argmax(tot)
        if tot.flat[j] > best: best = tot.flat[j]
    tot0 = k*np.exp(interp_vec(np.array([1.0]), np.array([0.0]), M))[0]
    return max(best, tot0)

def slice_ints(M):
    """所有切片 ∫exp(-M) dx (向量化 Gauss)"""
    Ls = S_GRID + eps
    xs = Ls[:, None]*(GL_X+1)/2          # (Ns, NG)
    ys = xs / Ls[:, None]                 # (Ns, NG) 相对位置
    s_flat = np.repeat(S_GRID, len(GL_X))
    y_flat = ys.flatten()
    em = np.exp(-interp_vec(s_flat, y_flat, M)).reshape(Ns, len(GL_X))
    # leggauss 权重在 [-1,1], 映射 [0,L]: ∫f = (L/2)Σw f(L(x+1)/2)
    out = np.sum(GL_W[None, :] * em, axis=1) * (Ls/2)
    return out

if __name__ == '__main__':
    M0 = np.zeros((Ns, Nx))
    for i, s in enumerate(S_GRID):
        L = s + eps
        for j, y in enumerate(Y_GRID):
            x = y*L
            M0[i, j] = np.log((s + 48*x)*np.log((49*s + 48*eps)/s)/48)
    v0 = sup_scan(M0, na=24)
    print(f'初始(论文形): sup={v0:.6f}', flush=True)
    cons = [{'type': 'ineq', 'fun': lambda mf, sj=sj: 1.0 - slice_int_single(sj, mf.reshape(Ns,Nx))}
            for sj in S_GRID]
    # 简化: 一次性约束
    def slice_int_single(s, M):
        L = s + eps
        xs = L*(GL_X+1)/2
        return np.sum(GL_W*np.exp(-interp_vec(np.full(len(xs), s), xs/L, M)))*L/2
    cons = [{'type': 'ineq', 'fun': lambda mf, sj=sj: 1.0 - slice_int_single(sj, mf.reshape(Ns,Nx))}
            for sj in S_GRID]
    def obj(mf, na=18):
        return sup_scan(mf.reshape(Ns,Nx), na=na)
    res = minimize(obj, M0.flatten(), method='SLSQP', constraints=cons,
                   options={'maxiter': 300, 'ftol': 1e-10, 'maxls': 40})
    print(f'SLSQP: sup={res.fun:.6f} success={res.success}', flush=True)
    v = sup_scan(res.x.reshape(Ns,Nx), na=50)
    print(f'验证: sup={v:.6f}  {"<4!!!" if v < 4 else ""}')
    for sj in S_GRID:
        print(f'  s={sj:.4f}: ∫G={slice_int_single(sj, res.x.reshape(Ns,Nx)):.6f}')
