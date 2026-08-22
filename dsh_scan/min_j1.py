#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""min_j1.py — 路线 B 的 J1 侧核心: 广义双因子 T 积分 (精确有理)
JT[k', c, a, B, B2, C] = ∫_{R'} m^B · (c - k'm - W)^a · (c - (k'-1)m - W)^{B2} · W^C dm dW
  区域 R' = {m≥0, W≥0, k'm + W ≤ c}  (k' 个坐标: m 一个 + W 由 k'-1 个 w 合成)
  这是 (1-ε)-区域上的 min 坐标展开核心; a, B, B2, C 非负整数, c 有理。
  闭式: 先对 W 积分 (上限 c-k'm, 被积 (L-W)^a (L+m-W)^{B2} W^C, L=c-k'm),
  再对 m ∈ [0, c/k'] 多项式展开积分。
用法: 模块提供 JT_exact(kp, c, a, B, B2, C, cache) → Fraction
"""
import math
from fractions import Fraction as Fr

def JT_exact(kp, c, a, B, B2, C, cache):
    key = (kp, c.numerator, c.denominator, a, B, B2, C)
    if key in cache:
        return cache[key]
    # 内层: ∫_0^L (L-W)^a (L+m-W)^{B2} W^C dW,  L = c - kp·m
    # (L+m-W)^{B2} = Σ_{s=0}^{B2} C(B2,s) m^{B2-s} (L-W)^s
    # 内层 = Σ_s C(B2,s) m^{B2-s} · L^{a+s+C+1} · a! s! C!/(a+s+C+1)!
    tot = Fr(0)
    for s in range(B2 + 1):
        cs = Fr(math.comb(B2, s)) * Fr(math.factorial(a + s) * math.factorial(C),
                                       math.factorial(a + s + C + 1))
        # 外层: ∫_0^{c/kp} m^{B+B2-s} · L^{a+s+C+1} dm, L = c - kp·m
        E = a + s + C + 1
        Bp = B + B2 - s
        for r in range(E + 1):
            Lr = Fr(math.comb(E, r)) * c ** (E - r) * ((-kp) ** r)
            pw = Bp + r
            tot += cs * Lr * (Fr(c, kp) ** (pw + 1)) / Fr(pw + 1)
    cache[key] = tot
    return tot

if __name__ == '__main__':
    # 自检: kp=2, c=1, 小参数 vs 直接二重 Simpson
    import numpy as np
    def num(kp, c, a, B, B2, C):
        N = 401
        xs = np.linspace(0, 1, N); h = xs[1] - xs[0]
        tot = 0.0
        for i in range(0, N - 1, 2):
            for j in range(0, N - 1, 2):
                for di in range(3):
                    for dj in range(3):
                        m = xs[i + di]; W = xs[j + dj]
                        if kp * m + W > c:
                            continue
                        wgt = (1 if di in (0, 2) else 4) * (1 if dj in (0, 2) else 4)
                        tot += wgt * m ** B * (c - kp * m - W) ** a * (c - (kp - 1) * m - W) ** B2 * W ** C
        return tot * (h / 3) ** 2
    cache = {}
    ok = True
    for (a, B, B2, C) in [(0, 0, 0, 0), (1, 0, 0, 0), (0, 1, 1, 0), (1, 1, 1, 1), (2, 0, 1, 0), (0, 2, 0, 1)]:
        ex = float(JT_exact(2, Fr(1), a, B, B2, C, cache))
        nu = num(2, 1.0, a, B, B2, C)
        r = ex / nu if nu else 0
        print(f'kp=2 a={a} B={B} B2={B2} C={C}: exact={ex:.10e} numeric={nu:.10e} ratio={r:.6f}')
        ok &= abs(r - 1) < 0.01
    print('ALL OK' if ok else 'MISMATCH')
