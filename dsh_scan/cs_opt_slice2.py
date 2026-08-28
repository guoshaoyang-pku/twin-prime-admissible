#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_opt_slice2.py — 逐切片独立 G(x;s) 的 minimax 优化
G(x;s) 参数化: s 网格 (Ns 点) × x 网格 (Nx 点) 的 log 值, 双线性插值
约束: 每切片 ∫_0^{s+eps} G dx = 1 (归一化在目标里: 1/G 乘 L·∫h)
sup 扫描: 对称 t 网格 (m,a,b)。
"""
import numpy as np
from scipy.optimize import minimize

k, eps = 49, 1/25
Ns, Nx = 7, 7
S_GRID = np.linspace(eps, 1+eps, Ns)           # 切片参数 s
X_GRID = np.linspace(0.0, 1.0, Nx)             # 相对位置 x/(s+eps)

def G_inv(s, x, M):
    """1/G(x;s), M: (Ns,Nx) log 值矩阵, 归一化 ∫G=1"""
    L = s + eps
    # s 方向插值
    si = np.clip(np.searchsorted(S_GRID, s, side='right')-1, 0, Ns-2)
    t_s = (s - S_GRID[si]) / (S_GRID[si+1] - S_GRID[si])
    y = min(max(x/L, 0.0), 1.0)
    xi = np.clip(np.searchsorted(X_GRID, y, side='right')-1, 0, Nx-2)
    t_x = (y - X_GRID[xi]) / (X_GRID[xi+1] - X_GRID[xi])
    def val(i, j):
        return M[i, j]
    h = ((1-t_s)*(1-t_x)*val(si,xi) + (1-t_s)*t_x*val(si,xi+1)
         + t_s*(1-t_x)*val(si+1,xi) + t_s*t_x*val(si+1,xi+1))
    # ∫_0^L G dx ≈ L·(x 网格梯形) —— 用 log 值的梯形? 不行, 要 G 值的梯形。
    # 对切片 s: ∫G dx = L·Σ_j w_j·G(x_j; s) (梯形权重, G = exp(M 插值))
    gvals = []
    for yv in X_GRID:
        xi2 = np.clip(np.searchsorted(X_GRID, yv, side='right')-1, 0, Nx-2)
        tx2 = (yv - X_GRID[xi2]) / (X_GRID[xi2+1] - X_GRID[xi2])
        gv = ((1-t_s)*((1-tx2)*val(si,xi2)+tx2*val(si,xi2+1))
              + t_s*((1-tx2)*val(si+1,xi2)+tx2*val(si+1,xi2+1)))
        gvals.append(np.exp(gv))
    gvals = np.array(gvals)
    w = np.ones(Nx); w[0] = 0.5; w[-1] = 0.5
    integ = L * np.sum(w * (X_GRID[1]-X_GRID[0]) * gvals)
    return np.exp(h) / integ if integ > 0 else 1e300

def sup_grid(M, na=40):
    best = -1e9; arg = None
    for m in range(1, k+1):
        aa = np.linspace(0, (1+eps)/m, na)
        bb = np.linspace(0, (1+eps)/max(1,k-m), na)
        for a in aa:
            for b in bb:
                u = m*a + (k-m)*b
                if u > 1+eps + 1e-12: continue
                tot = 0.0
                s_a = 1-u+a
                if s_a >= eps-1e-12 and m > 0:
                    tot += m * G_inv(s_a, a, M)
                s_b = 1-u+b
                if s_b >= eps-1e-12 and k-m > 0:
                    tot += (k-m) * G_inv(s_b, b, M)
                if tot > best: best, arg = tot, (m,a,b)
    return best, arg

if __name__ == '__main__':
    # 初始: 论文形 G ∝ 1/(s+48x) 逐切片归一化
    M0 = np.zeros((Ns, Nx))
    for i, s in enumerate(S_GRID):
        L = s + eps
        for j, y in enumerate(X_GRID):
            x = y*L
            M0[i, j] = np.log(1.0/(s + (k-1)*x))  # 未归一化形状
    # 实际归一化在 G_inv 里做, 所以 log 形状直接给
    v0, arg0 = sup_grid(M0, na=35)
    print(f'初始(论文形逐切片) sup = {v0:.6f} (m={arg0[0]}, a={arg0[1]:.4f}, b={arg0[2]:.4f})')
    def obj(mflat):
        M = mflat.reshape(Ns, Nx)
        v, _ = sup_grid(M, na=30)
        return v
    res = minimize(obj, M0.flatten(), method='Nelder-Mead',
                   options={'maxiter': 3000, 'xatol': 1e-7, 'fatol': 1e-9, 'maxfev': 3000})
    print(f'优化后: {res.fun:.6f}  {"<4!!!" if res.fun < 4 else ""}')
    M_opt = res.x.reshape(Ns, Nx)
    v, arg = sup_grid(M_opt, na=60)
    print(f'验证 sup = {v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})')
    print('最优形状 (行=s 网格, 列=x 网格):')
    print(np.round(M_opt, 3))
