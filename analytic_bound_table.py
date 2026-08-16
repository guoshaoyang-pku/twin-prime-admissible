#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
analytic_bound_table.py — 解析上界 a-优化 严格值表（论文 Polymath8b Remark, newergap-submitted.tex line 1979）
    M_{k,eps} <= min_{1/(1+eps) < a < 1/(1-eps)} (k/(a(k-1))) * log( k + ((a(1+eps)-1)(k-1))/(1-a(1-eps)) )
关键事实（本脚本验证）：对 k=44..50, eps∈{1/25,1/50,1/100}，该函数在可行区间内单调递增，
最小值在左端点 a→1/(1+eps)+ 处取得，故 a-优化界 = 端点极限 = k(1+eps)/(k-1)·log k
（严格成立：M <= bound_a 对所有 a 成立，取 a→1/(1+eps)+ 的极限）。
"""
import math

def bound_a(k, eps, a):
    num = (a * (1 + eps) - 1) * (k - 1)
    den = 1 - a * (1 - eps)
    return (k / (a * (k - 1))) * math.log(k + num / den)

def a_opt_bound(k, eps):
    """在 (1/(1+eps), 1/(1-eps)) 上对 a 精细扫描 + 端点比较，返回 (最优值, 最优a)"""
    lo = 1.0 / (1 + eps); hi = 1.0 / (1 - eps)
    vlo = (k * (1 + eps) / (k - 1)) * math.log(k)   # 端点极限
    best = (vlo, lo)
    N = 400000
    for i in range(1, N):
        a = lo + (hi - lo) * i / N
        v = bound_a(k, eps, a)
        if v < best[0]:
            best = (v, a)
    return best

if __name__ == "__main__":
    print("k  eps      a-opt 上界   最优a         端点公式 k(1+e)/(k-1)log k")
    for k in [44, 45, 46, 47, 48, 49, 50]:
        for epsd in [25, 50, 100]:
            eps = 1.0 / epsd
            v, a = a_opt_bound(k, eps)
            vlo = (k * (1 + eps) / (k - 1)) * math.log(k)
            mark = "  <4 排除" if v < 4 else "  >4 未排除"
            print(f"{k:3d}  1/{epsd:<3d}   {v:.6f}    {a:.6f}        {vlo:.6f}{mark}")
        print()
