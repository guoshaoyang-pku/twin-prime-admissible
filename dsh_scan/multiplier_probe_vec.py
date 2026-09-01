#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""multiplier_probe_vec.py — 向量化乘子探针: N(t) = ΣWᵢ − λ*·w 与 m_w = ΣWᵢ/w
区域定义与 frac_multi.py 逐行对齐 (同 multiplier_engine.py)。
用法: python3 multiplier_probe_vec.py <w.json> <lambda_star> [D]
"""
import sys, json
import numpy as np
sys.path.insert(0, '.')
from multiplier_engine import build_basis, w_edge_expand, mw_sym

k, eps = 49, 1/25

def load_w(wf, D):
    wd = json.load(open(wf))
    wcoeff = {}
    for key, val in wd.items():
        r, gamma = key.split(';')
        gamma = tuple(map(int, gamma.split(','))) if gamma else ()
        wcoeff[(int(r), gamma)] = float(val)
    return wcoeff

def poly_sym_vec(coeff, M, A, B):
    tot = np.zeros_like(A, dtype=float)
    kk = k
    for lam, c in coeff.items():
        v = np.ones_like(A)
        for d in lam:
            v *= (M * A ** d + (kk - M) * B ** d)
        tot += c * v
    return tot

def probe(wcoeff, edge, lam_star, n_grid=50, n_rand=30000, seed=7):
    """网格 + 随机探针: 返回 (m_w_max, arg, N<0 比例)"""
    rng = np.random.default_rng(seed)
    worst = -1e9; arg = None; negN = 0; totN = 0
    for m in range(1, k + 1):
        aa = np.linspace(1e-6, (1 + eps) / m, n_grid)
        bb = np.linspace(0, (1 + eps) / max(1, k - m), n_grid)
        A, B = np.meshgrid(aa, bb, indexing='ij')
        U = m * A + (k - m) * B
        ok = U <= 1 + eps + 1e-12
        W = np.zeros_like(A)
        for (r, gamma), c in wcoeff.items():
            p = np.ones_like(A)
            for d in gamma:
                p *= (m * A ** d + (k - m) * B ** d)
            W += c * (1 + eps - U) ** r * p
        num = np.zeros_like(A)
        va = ok & (m > 0) & (U - A <= 1 - eps + 1e-12)
        if va.any():
            num[va] += m * poly_sym_vec(edge, m - 1, A[va], B[va])
        vb = ok & (k - m > 0) & (U - B <= 1 - eps + 1e-12)
        if vb.any():
            num[vb] += (k - m) * poly_sym_vec(edge, m, A[vb], B[vb])
        with np.errstate(divide='ignore', invalid='ignore'):
            mw = np.where((W > 0) & ok, num / np.where(W > 0, W, 1), -1e9)
        j = np.argmax(mw)
        if mw.flat[j] > worst:
            worst = mw.flat[j]; arg = (m, A.flat[j], B.flat[j])
        negN += int(np.sum((mw - lam_star * k < 0) & (W > 0) & ok))
        totN += int(np.sum((W > 0) & ok))
    for _ in range(n_rand):
        m = int(rng.integers(1, k + 1))
        a = rng.uniform(0, (1 + eps) / m)
        b = rng.uniform(0, (1 + eps) / max(1, k - m))
        mw = mw_sym(wcoeff, [edge, edge], m, a, b)
        if mw is None:
            continue
        totN += 1
        if mw - lam_star * k < 0:
            negN += 1
        if mw > worst:
            worst, arg = mw, (m, a, b)
    return worst, arg, negN, totN

if __name__ == '__main__':
    wf = sys.argv[1]
    lam_star = float(sys.argv[2])
    D = int(sys.argv[3]) if len(sys.argv) > 3 else 19
    wcoeff = load_w(wf, D)
    edge = w_edge_expand(wcoeff, 0)
    print(f'w 基元素 {len(wcoeff)}, W 展开 {len(edge)} 项', flush=True)
    worst, arg, negN, totN = probe(wcoeff, edge, lam_star)
    print(f'm_w max ≈ {worst:.6f} at (m={arg[0]}, a={arg[1]:.5f}, b={arg[2]:.5f})')
    print(f'λ*·k = {lam_star*k:.6f};  N(t)<0 比例 {negN}/{totN} = {negN/max(totN,1):.4f}')
    print(f'结论: {"m_w ≤ λ*·k 探针通过 (<4 证书候选)" if worst < 4 else "探针未通过 (>4)"}')
