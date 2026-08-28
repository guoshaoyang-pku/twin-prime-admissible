#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""conv_fit.py — 论文基 M_{49,1/25}(D) 收敛率拟合与外推 (5 严格点)
用法: python3 conv_fit.py [D31_M]   # 给 D=31 高精度值则计入
拟合: 增量 ΔD = M(D)-M(D-2) ≈ A·q^D (几何衰减) → 极限 = M(31) + ΣΔ
同时给 Aitken Δ² 与外推区间。"""
import sys

# 论文基严格值 (D=25/27/29 为 640 位精确 Rayleigh 收敛, D=31 为 legendre_fix 高精度)
pts = {25: 3.9843342389, 27: 3.9870762843, 29: 3.9887309107}
if len(sys.argv) > 1:
    pts[31] = float(sys.argv[1])

Ds = sorted(pts)
Ms = [pts[d] for d in Ds]
print(f"数据点 (论文基 ε=1/25): " + "  ".join(f"D={d}: {pts[d]:.10f}" for d in Ds))

# 每 2 步增量
incs = [(Ds[i+1], Ms[i+1]-Ms[i]) for i in range(len(Ds)-1)]
print("\n增量 (per 2-D):")
for d, inc in incs:
    print(f"  Δ({d-2}→{d}) = {inc:.8f}")

# 几何拟合: ln inc = ln A + D ln q  (用全部增量)
import numpy as np
if len(incs) >= 2:
    xs = np.array([float(d) for d, _ in incs])
    ys = np.array([float(inc) for _, inc in incs])
    # 用最后两段估计 q
    qs = [ys[i+1]/ys[i] for i in range(len(ys)-1)]
    print(f"\n增量比: {[f'{q:.4f}' for q in qs]}")
    q_geo = np.exp(np.mean([np.log(q) for q in qs]))
    A = ys[-1] / q_geo**xs[-1]
    print(f"几何拟合: Δ ≈ {A:.2f} × {q_geo:.4f}^D")
    tail = sum(A * q_geo**d for d in range(Ds[-1]+2, 200, 2))
    lim = Ms[-1] + tail
    print(f"外推极限 ≈ {lim:.6f}  (余项 {tail:.6f}, 裕量 {4-lim:.6f})")

    # Aitken Δ² 用最后三点
    if len(Ms) >= 3:
        m1, m2, m3 = Ms[-3], Ms[-2], Ms[-1]
        ait = m3 - (m3-m2)**2 / ((m3-m2)-(m2-m1))
        print(f"Aitken Δ² (最后三点): {ait:.6f}")

    # 保守区间: 用最后一段增量比 q_last (观测衰减率单调递减 ⟹ 余项 ≤ 用 q_last 的几何和)
    q_last = qs[-1]
    tail_hi = sum((ys[-1]/q_last**xs[-1]) * q_last**d for d in range(Ds[-1]+2, 200, 2))
    print(f"保守上界 (q→q_last={q_last:.4f}, 观测比单调递减): {Ms[-1]+tail_hi:.6f}  (裕量 {4-(Ms[-1]+tail_hi):.6f})")
