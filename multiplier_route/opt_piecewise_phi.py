#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""opt_piecewise_phi.py — 分段线性 φ(u,t) 网格优化 (per-i 对偶权族)
φ 为 (u,t) 平面三角域上的分段双线性函数 (网格节点值为变量)
用法: python3 opt_piecewise_phi.py [N_u] [N_t] [maxiter] [seed]
"""
import numpy as np, math, sys, json, time
from scipy.optimize import differential_evolution

k, eps = 49, 1/25
E = 1 + eps
NU = int(sys.argv[1]) if len(sys.argv) > 1 else 10
NT = int(sys.argv[2]) if len(sys.argv) > 2 else 10
MAXITER = int(sys.argv[3]) if len(sys.argv) > 3 else 25
SEED = int(sys.argv[4]) if len(sys.argv) > 4 else 5

# 网格节点: u_i = i*E/NU (i=0..NU), t_j = j*E/NT (j=0..NT), 约束 u+t<=E
nodes = [(i, j) for i in range(NU+1) for j in range(NT+1) if i/NU + j/NT <= 1.0 + 1e-9]
NN = len(nodes)
print(f"grid {NU}x{NT}: {NN} nodes", flush=True)

def phi_from_nodes(vals):
    """返回 phi(u,t) 函数 (双线性插值)"""
    vmap = {nodes[idx]: vals[idx] for idx in range(NN)}
    def phi(u, t):
        if u < 0 or t < 0 or u + t > E + 1e-12:
            return 0.0
        i = int(u / E * NU); j = int(t / E * NT)
        i = min(i, NU-1); j = min(j, NT-1)
        u0, u1 = i*E/NU, (i+1)*E/NU
        t0, t1 = j*E/NT, (j+1)*E/NT
        su = (u-u0)/(u1-u0) if u1 > u0 else 0
        st = (t-t0)/(t1-t0) if t1 > t0 else 0
        # 需要四角值; 若角在域外, 用域内角近似
        def val(ii, jj):
            key = (min(ii, NU), min(jj, NT))
            if key in vmap:
                return vmap[key]
            # 域外角: 最近域内节点
            best = None; bd = 1e9
            for kk in vmap:
                d = (kk[0]-key[0])**2 + (kk[1]-key[1])**2
                if d < bd: bd, best = d, kk
            return vmap[best]
        v00, v10, v01, v11 = val(i,j), val(i+1,j), val(i,j+1), val(i+1,j+1)
        return (1-su)*(1-st)*v00 + su*(1-st)*v10 + (1-su)*st*v01 + su*st*v11
    return phi

def H_integral(L, phi, n=200):
    xs = np.linspace(0, L, n)
    u = L - xs
    vals = np.array([phi(uu, x) for uu, x in zip(u, xs)])
    if (vals <= 0).any():
        return None
    return np.trapezoid(1.0/vals, xs)

def sup_m(vals, N=50, M=14, verbose=False):
    phi = phi_from_nodes(vals)
    best = 0.0; bestloc = None
    Ls = np.linspace(1e-6, E, 3*N)
    Htab = {}
    for L in Ls:
        v = H_integral(L, phi)
        if v is None:
            return 1e9
        Htab[L] = v
    Hkeys = sorted(Htab)
    def H(L):
        i = min(range(len(Hkeys)), key=lambda j: abs(Hkeys[j]-L))
        return Htab[Hkeys[i]]
    for u in np.linspace(1e-4, E, N):
        C = E - u
        t_eq = C/k
        if t_eq >= 2*eps-u:
            m = k*phi(u, t_eq)*H(u+t_eq)
            if m > best: best, bestloc = m, ('eq', u, t_eq)
        if C >= 2*eps-u:
            m = phi(u, C)*H(u+C)
            if m > best: best, bestloc = m, ('single', u, C)
        if C/2 >= 2*eps-u:
            m = 2*phi(u, C/2)*H(u+C/2)
            if m > best: best, bestloc = m, ('two', u, C/2)
        for x in np.linspace(0, C, M):
            y = (C-x)/(k-1)
            m = 0.0
            if x >= 2*eps-u: m += phi(u, x)*H(u+x)
            if y >= 2*eps-u: m += (k-1)*phi(u, y)*H(u+y)
            if m > best: best, bestloc = m, ('mix', u, x, y)
    if verbose: print(f"sup={best:.4f} at {bestloc}", flush=True)
    return best

if __name__ == '__main__':
    t0 = time.time()
    # 起点: 线性族 φ = 1 + a*q, a=1/E — 作为节点初值
    a0 = 1/E
    def lin_phi(u, t):
        return 1 + a0*(u + k*t - E)
    init = np.array([max(lin_phi(nodes[i][0]*E/NU, nodes[i][1]*E/NT), 1e-6) for i in range(NN)])
    base = sup_m(init)
    print(f"线性族基线 (网格离散): sup = {base:.4f} ({time.time()-t0:.0f}s)", flush=True)
    # DE: 变量为节点值 (正, 范围 [1e-6, 50])
    bounds = [(1e-6, 50.0)]*NN
    res = differential_evolution(sup_m, bounds, seed=SEED, maxiter=MAXITER,
                                 tol=1e-2, workers=1, updating='immediate', polish=True)
    print(f"DE 结果: sup = {res.fun:.6f} ({time.time()-t0:.0f}s)", flush=True)
    sup_m(res.x, verbose=True)
    json.dump({'nu': NU, 'nt': NT, 'nodes': nodes, 'vals': res.x.tolist(),
               'sup': res.fun, 'baseline': float(base)}, open(f'piecewise_phi_{NU}x{NT}.json', 'w'))
    print(f"saved piecewise_phi_{NU}x{NT}.json", flush=True)
