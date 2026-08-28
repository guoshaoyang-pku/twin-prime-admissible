#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_minimax_slsqp.py — 修复版 CS 上界 minimax (SLSQP, 约束 ∫G≤1)
M = log(1/G) 形状参数化 (Ns×Nx 双线性插值, 无归一化)
约束: 每切片 s_j: ∫_0^{s_j+eps} exp(-M) dx <= 1   (G = exp(-M))
目标: min max_t Σ_{有效} exp(M(t_i; s_i))
"""
import numpy as np
from scipy.optimize import minimize
from numpy.polynomial.legendre import leggauss

k, eps = 49, 1/25
ONE = 1+eps
Ns, Nx = 7, 7
S_GRID = np.array([eps + (ONE-eps)*i/(Ns-1) for i in range(Ns)])
Y_GRID = np.linspace(0.0, 1.0, Nx)
GL_X, GL_W = leggauss(48)

def interp(s, y, M):
    si = np.clip(np.searchsorted(S_GRID, s, side='right')-1, 0, Ns-2)
    ts = (s - S_GRID[si])/(S_GRID[si+1]-S_GRID[si])
    y = min(max(y, 0.0), 1.0)
    yi = np.clip(np.searchsorted(Y_GRID, y, side='right')-1, 0, Nx-2)
    ty = (y - Y_GRID[yi])/(Y_GRID[yi+1]-Y_GRID[yi])
    return ((1-ts)*(1-ty)*M[si,yi] + (1-ts)*ty*M[si,yi+1]
            + ts*(1-ty)*M[si+1,yi] + ts*ty*M[si+1,yi+1])

def slice_integral(s, M):
    """∫_0^{s+eps} exp(-M) dx (Gauss 48 点)"""
    L = s + eps
    xs = L*(GL_X+1)/2
    return np.sum(GL_W * np.exp(-np.array([interp(s, x/L, M) for x in xs]))) * L/2

def sup_scan(M, na=22):
    best = -1e9; arg = None
    for m in range(1, k+1):
        for a in np.linspace(1e-9, ONE/m, na):
            for b in np.linspace(0, ONE/max(1,k-m), na):
                u = m*a + (k-m)*b
                if u > ONE + 1e-12: continue
                tot = 0.0
                s_a = 1-u+a
                if m > 0 and s_a >= eps - 1e-12:
                    tot += m * np.exp(interp(s_a, a/(s_a+eps), M))
                s_b = 1-u+b
                if k-m > 0 and s_b >= eps - 1e-12:
                    tot += (k-m) * np.exp(interp(s_b, b/(s_b+eps), M))
                if tot > best: best, arg = tot, (m,a,b)
    tot0 = k * np.exp(interp(1.0, 0.0, M))
    if tot0 > best: best, arg = tot0, (0,0,0)
    return best, arg

if __name__ == '__main__':
    # 论文形 1/G = (s+48x)·ln((49s+48eps)/s)/48 (满足 ∫G=1 精确)
    M0 = np.zeros((Ns, Nx))
    for i, s in enumerate(S_GRID):
        L = s + eps
        for j, y in enumerate(Y_GRID):
            x = y*L
            M0[i, j] = np.log((s + 48*x)*np.log((49*s + 48*eps)/s)/48)
    v0, arg0 = sup_scan(M0, na=20)
    print(f'初始(论文形): sup={v0:.6f} (m={arg0[0]}, a={arg0[1]:.4f}, b={arg0[2]:.4f})', flush=True)
    # 约束: 每切片 ∫exp(-M) <= 1
    cons = [{'type': 'ineq', 'fun': lambda mf, sj=sj: 1.0 - slice_integral(sj, mf.reshape(Ns,Nx))}
            for sj in S_GRID]
    def obj(mf, na=16):
        return sup_scan(mf.reshape(Ns,Nx), na=na)[0]
    res = minimize(obj, M0.flatten(), method='SLSQP', constraints=cons,
                   options={'maxiter': 200, 'ftol': 1e-10})
    print(f'SLSQP: sup={res.fun:.6f}  success={res.success}', flush=True)
    v, arg = sup_scan(res.x.reshape(Ns,Nx), na=40)
    print(f'验证: sup={v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})  {"<4!!!" if v < 4 else ""}')
    # 约束检查
    for sj in S_GRID:
        print(f'  s={sj:.4f}: ∫G = {slice_integral(sj, res.x.reshape(Ns,Nx)):.6f}')
