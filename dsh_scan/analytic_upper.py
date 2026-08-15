#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Analytic upper bounds for M_{k,eps} (Polymath8b Prop mkeps + a-optimized remark):
    M_{k,eps} <= min over a in (1/(1+eps), 1/(1-eps)) of
        (k/(a*(k-1))) * log( k + ((a*(1+eps)-1)*(k-1)) / (1 - a*(1-eps)) )
    Also the plain bound a=1: (k/(k-1))*log(2k-1) and the eps->0 limit M_k <= (k/(k-1))*log k.
"""
import math

def bound_a(k, eps, a):
    num = (a * (1 + eps) - 1) * (k - 1)
    den = 1 - a * (1 - eps)
    return (k / (a * (k - 1))) * math.log(k + num / den)

def bound(k, eps):
    lo = 1.0 / (1 + eps) + 1e-12
    hi = 1.0 / (1 - eps) - 1e-12
    best = (None, None)
    # golden-section / grid search
    N = 200000
    for i in range(N + 1):
        a = lo + (hi - lo) * i / N
        v = bound_a(k, eps, a)
        if best[0] is None or v < best[0]:
            best = (v, a)
    return best[0], best[1]

print("k  eps     M_k_eps_upper(a=1)   M_k_eps_upper(opt a)   a*      M_k<=(k/(k-1))log k")
for k in range(40, 52):
    for eps in [0.04, 0.02, 0.01]:
        b1 = (k / (k - 1)) * math.log(2 * k - 1)
        bo, ao = bound(k, eps)
        bk = (k / (k - 1)) * math.log(k)
        print(f"{k:3d}  {eps:.3f}   {b1:.6f}              {bo:.6f}           {ao:.6f}   {bk:.6f}")
    print()
