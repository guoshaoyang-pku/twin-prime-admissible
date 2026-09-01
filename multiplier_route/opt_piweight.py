#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""opt_piweight.py — 优化 per-i 对偶权族 φ(u,t) 使 sup m <= 4
m(t) = Σ_{i: t_i>=2ε−u} φ(u,t_i)·H(u+t_i), H(L)=∫_0^L dx/φ(L−x,x)
用法: python3 opt_piweight.py [maxiter]
"""
import numpy as np, math, sys, json
from scipy.optimize import differential_evolution

k, eps = 49, 1/25
E = 1 + eps

def make_phi(pars):
    a, b, c, d, e = pars
    def phi(u, t):
        q = u + k*t - E
        return 1 + a*q + b*q*q + c*q*q*q + d*u*t + e*t*t
    return phi

def H_integral(L, phi, n=160):
    xs = np.linspace(0, L, n)
    u = L - xs
    vals = np.array([phi(uu, x) for uu, x in zip(u, xs)])
    if (vals <= 0).any():
        return None
    return np.trapezoid(1.0/vals, xs)

def sup_m(pars, N=80, M=22):
    phi = make_phi(pars)
    best = 0.0
    # H 表
    Ls = np.linspace(1e-6, E, 4*N)
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
        if t_eq >= 2*eps - u:
            m = k*phi(u, t_eq)*H(u+t_eq)
            if m > best: best = m
        if C >= 2*eps - u:
            m = phi(u, C)*H(u+C)
            if m > best: best = m
        if C/2 >= 2*eps - u:
            m = 2*phi(u, C/2)*H(u+C/2)
            if m > best: best = m
        for x in np.linspace(0, C, M):
            y = (C-x)/(k-1)
            m = 0.0
            if x >= 2*eps-u: m += phi(u, x)*H(u+x)
            if y >= 2*eps-u: m += (k-1)*phi(u, y)*H(u+y)
            if m > best: best = m
    return best

if __name__ == '__main__':
    MAXITER = int(sys.argv[1]) if len(sys.argv) > 1 else 50
    base = sup_m([1/E, 0, 0, 0, 0])
    print(f"基线 (a=1/E): sup = {base:.4f}", flush=True)
    bounds = [(-0.5, 2.5), (-8, 8), (-20, 20), (-8, 8), (-8, 8)]
    res = differential_evolution(sup_m, bounds, seed=3, maxiter=MAXITER,
                                 tol=1e-3, workers=1, polish=True, updating='immediate')
    print(f"优化结果 pars={res.x} sup={res.fun:.6f}", flush=True)
    json.dump({'pars': res.x.tolist(), 'sup': res.fun, 'baseline': base}, open('piweight_opt.json', 'w'))
    print("saved piweight_opt.json", flush=True)
