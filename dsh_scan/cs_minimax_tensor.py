#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_minimax_tensor.py — 修复版 CS 上界 minimax: min_G sup_t Σ_{有效}1/G_i(t)
G_i(t) = G(x; s), x = t_i, s = 1-Σ_{j≠i}t_j, 逐切片 ∫_0^{s+eps} G dx = 1
参数化: log G 在 (s 网格) × (y=x/L 网格) 上的张量值, 双线性插值, 归一化由 ∫=1 吸收
sup 扫描: 对称 t (m 个 a, k-m 个 b) 网格 + u=0 点
"""
import numpy as np
from scipy.optimize import minimize
from math import exp

k, eps = 49, 1/25
ONE = 1+eps

Ns, Nx = 7, 7
S_GRID = np.array([eps + (ONE-eps)*i/(Ns-1) for i in range(Ns)])
Y_GRID = np.linspace(0.0, 1.0, Nx)

def interp_logG(s, y, M):
    """log G(x;s): 双线性插值, M: (Ns,Nx)"""
    si = np.clip(np.searchsorted(S_GRID, s, side='right')-1, 0, Ns-2)
    ts = (s - S_GRID[si])/(S_GRID[si+1]-S_GRID[si])
    y = min(max(y, 0.0), 1.0)
    yi = np.clip(np.searchsorted(Y_GRID, y, side='right')-1, 0, Nx-2)
    ty = (y - Y_GRID[yi])/(Y_GRID[yi+1]-Y_GRID[yi])
    v = ((1-ts)*(1-ty)*M[si,yi] + (1-ts)*ty*M[si,yi+1]
         + ts*(1-ty)*M[si+1,yi] + ts*ty*M[si+1,yi+1])
    return v

def slice_norm(s, M):
    """∫_0^{s+eps} G dx (数值, 用 G 网格插值)"""
    L = s + eps
    # 在切片上用 Y_GRID 的采样
    tot = 0.0
    for iy in range(Nx):
        y = Y_GRID[iy]
        w = (Y_GRID[1]-Y_GRID[0]) * (0.5 if iy in (0, Nx-1) else 1.0)
        tot += w * exp(interp_logG(s, y, M)) * L
    return tot

def invG(s, x, M):
    """1/G(x;s)"""
    L = s + eps
    return L / slice_norm(s, M) * exp(interp_logG(s, x/L, M))

def sup_scan(M, na=24):
    best = -1e9; arg = None
    for m in range(1, k+1):
        for a in np.linspace(1e-9, ONE/m, na):
            for b in np.linspace(0, ONE/max(1,k-m), na):
                u = m*a + (k-m)*b
                if u > ONE + 1e-12: continue
                tot = 0.0
                s_a = 1-u+a
                if m > 0 and s_a >= eps - 1e-12:
                    tot += m * invG(s_a, a, M)
                s_b = 1-u+b
                if k-m > 0 and s_b >= eps - 1e-12:
                    tot += (k-m) * invG(s_b, b, M)
                if tot > best: best, arg = tot, (m, a, b)
    # u=0: 所有切片有效, s=1, x=0
    tot0 = k * invG(1.0, 0.0, M)
    if tot0 > best: best, arg = tot0, (0, 0, 0)
    return best, arg

if __name__ == '__main__':
    # 初始: 论文形 G ∝ 1/(s+48x) 逐切片归一化 (log 形状)
    M0 = np.zeros((Ns, Nx))
    for i, s in enumerate(S_GRID):
        L = s + eps
        for j, y in enumerate(Y_GRID):
            x = y*L
            M0[i, j] = -np.log(s + (k-1)*x)
    v0, arg0 = sup_scan(M0, na=20)
    print(f'初始(论文形逐切片): sup={v0:.6f} (m={arg0[0]}, a={arg0[1]:.4f}, b={arg0[2]:.4f})', flush=True)
    def obj(mflat, na=16):
        M = mflat.reshape(Ns, Nx)
        return sup_scan(M, na=na)[0]
    res = minimize(obj, M0.flatten(), method='Powell',
                   options={'maxiter': 60, 'xtol': 1e-5, 'ftol': 1e-9})
    print(f'Powell 优化: sup={res.fun:.6f}', flush=True)
    v, arg = sup_scan(res.x.reshape(Ns,Nx), na=40)
    print(f'验证: sup={v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})  {"<4!!!" if v < 4 else ""}')
    print('logG 网格:')
    print(np.round(res.x.reshape(Ns,Nx), 3))
