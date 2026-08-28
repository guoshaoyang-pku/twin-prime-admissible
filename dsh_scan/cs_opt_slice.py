#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cs_opt_slice.py — 逐切片分段线性 G 的 minimax 优化 (min_G sup_t Σ_{有效}1/G_i)
G(x; s) 只依赖 x 和 L = s+eps (归一化相对节点): 节点 y_j ∈ [0,1], 值 h_j (log 参数)
∫_0^L G dx = L·(h 的梯形积分) = 1 ⟹ 1/G(x) = L·trapz(h)/h(y)
sup 扫描: 对称 t 网格 (m,a,b) + 局部精化。SLSQP 优化 log h。
"""
import numpy as np
from scipy.optimize import minimize

k, eps = 49, 1/25
NODES = np.array([0.0, 0.15, 0.35, 0.55, 0.75, 1.0])

def h_val(y, h):
    y = np.clip(y, 0.0, 1.0)
    i = np.searchsorted(NODES, y, side='right') - 1
    i = np.clip(i, 0, len(NODES)-2)
    t = (y - NODES[i]) / (NODES[i+1] - NODES[i])
    return h[i]*(1-t) + h[i+1]*t

def trapz_h(h):
    return np.sum((NODES[1:]-NODES[:-1]) * (h[:-1]+h[1:])/2)

def invG_vec(s_arr, x_arr, logh):
    """向量化 1/G(s,x)"""
    h = np.exp(logh)
    th = trapz_h(h)
    L = s_arr + eps
    y = x_arr / L
    hv = h_val(y, h)
    return L * th / hv

def sup_grid(logh, na=45, verbose=False):
    """对称 t 网格扫描 sup Σ_{有效}1/G_i"""
    h = np.exp(logh)
    th = trapz_h(h)
    best = -1e9; arg = None
    # 预计算 invG 对 (s,x) 的查找——用网格扫描
    for m in range(1, k+1):
        aa = np.linspace(0, (1+eps)/m, na)
        bb = np.linspace(0, (1+eps)/max(1, k-m), na)
        for a in aa:
            u_base = m*a
            for b in bb:
                u = u_base + (k-m)*b
                if u > 1+eps + 1e-12: continue
                # 有效坐标: s_i = 1-u+t_i >= eps
                s_a = 1 - u + a; s_b = 1 - u + b
                tot = 0.0
                if s_a >= eps - 1e-12 and m > 0:
                    L = s_a + eps; y = a/L
                    tot += m * L * th / h_val(y, h)
                if s_b >= eps - 1e-12 and k-m > 0:
                    L = s_b + eps; y = b/L
                    tot += (k-m) * L * th / h_val(y, h)
                if tot > best:
                    best = tot; arg = (m, a, b)
    return best, arg

def obj(logh):
    v, _ = sup_grid(logh, na=40)
    return v

if __name__ == '__main__':
    # 初始: 论文形 G ∝ 1/(s+48x) ⟹ 1/G = (s+48x)·ln((ks+(k-1)eps)/s)/48 —— 相对形状 h(y) ∝ 1/(1+48y·L/s)?? 不对, 用"1/x 型"初始
    # 先算论文形(β=1.2)的等效 h: 1/G ∝ (βs+48x) ⟹ h(y) ∝ 1/(β+48y·(L/s))? 依赖 s。粗略: h ∝ 1/(1.2+48y·L/s0), s0=(1+eps)/2
    s0 = (1+eps)/2
    L0 = s0 + eps
    h_init = 1.0/(1.2 + 48*NODES*L0/s0)
    logh0 = np.log(h_init)
    print('初始 h:', np.round(h_init, 4))
    v0, arg0 = sup_grid(logh0)
    print(f'初始 sup = {v0:.6f} (m={arg0[0]}, a={arg0[1]:.4f}, b={arg0[2]:.4f})')
    res = minimize(obj, logh0, method='Nelder-Mead',
                   options={'maxiter': 3000, 'xatol': 1e-8, 'fatol': 1e-10})
    print(f'优化后: {res.fun:.6f}  {"<4!!!" if res.fun < 4 else ""}')
    h_opt = np.exp(res.x)
    print('最优 h:', np.round(h_opt, 4))
    v, arg = sup_grid(res.x, na=70)
    print(f'验证 sup = {v:.6f} (m={arg[0]}, a={arg[1]:.4f}, b={arg[2]:.4f})')
