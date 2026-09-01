#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""multiplier_interval.py — 乘子 m_w(t) 的区间评估 (arb 区间算术)
对给定 t（或 t 的区间盒），严格计算 m_w(t) = Σ_{有效}Wᵢ(t_{≠i})/w(t) 的区间。
区域定义与 frac_multi.py 逐行对齐。用法: python3 multiplier_interval.py <w.json> <t_json>
"""
import sys, json
sys.path.insert(0, '.')
from flint import arb, acb
import flint

k, eps = 49, 1/25
flint.ctx.prec = 2000

def load_w(wf):
    wd = json.load(open(wf))
    wcoeff = {}
    for key, val in wd.items():
        r, gamma = key.split(';')
        gamma = tuple(map(int, gamma.split(','))) if gamma else ()
        if isinstance(val, str) and '/' in val:
            num, den = val.split('/')
        elif isinstance(val, str):
            num, den = val, '1'
        else:
            num, den = str(val), '1'
        wcoeff[(int(r), gamma)] = (int(num), int(den))
    return wcoeff

def p_lambda_iv(lam, tv):
    """p_λ(t) 区间: Π_{d∈λ}(Σ_j t_j^d)"""
    v = arb(1)
    for d in lam:
        s = arb(0)
        for x in tv:
            s += x ** d
        v *= s
    return v

def eval_poly_iv(coeff, tv):
    tot = arb(0)
    for lam, coef in coeff.items():
        coef = arb(int(coef.numerator)) / arb(int(coef.denominator))
        tot += coef * p_lambda_iv(lam, tv)
    return tot

def w_eval_iv(wcoeff, tv):
    u = sum(tv)
    wv = arb(0)
    for (r, gamma), coef in wcoeff.items():
        coef = arb(int(coef.numerator)) / arb(int(coef.denominator))
        p = arb(1)
        for d in gamma:
            s = arb(0)
            for x in tv:
                s += x ** d
            p *= s
        wv += coef * (arb(1) + arb(eps) - u) ** r * p
    return wv

def mw_iv(wcoeff, edge_coeff, t):
    """m_w(t) 的严格区间 (arb)"""
    tv = [arb(float(x)) for x in t]
    wv = w_eval_iv(wcoeff, tv)
    if wv.lower() <= 0:
        return None  # w 非正（或区间跨 0）——证书失败
    num = arb(0)
    u = sum(tv)
    for i in range(k):
        t_ne = tv[:i] + tv[i+1:]
        u_ne = u - tv[i]
        if u_ne.lower() <= 1 - eps + 1e-12:   # 有效切片（保守: 区间下界判定）
            num += eval_poly_iv(edge_coeff[i], t_ne)
    return num / wv

if __name__ == '__main__':
    wf = sys.argv[1]
    tjson = sys.argv[2]
    from multiplier_engine import w_edge_expand, build_basis
    from fractions import Fraction as Fr
    wcoeff_fr = {k2: Fr(*v) for k2, v in load_w(wf).items()}
    edge = [w_edge_expand(wcoeff_fr, i) for i in range(k)]
    t = json.load(open(tjson))
    mw = mw_iv(wcoeff_fr, edge, t)
    print(f't = {t}')
    if mw is None:
        print('w 在 t 处非正或区间跨 0 → 证书失败')
    else:
        print(f'm_w(t) ∈ [{float(mw.lower()):.10f}, {float(mw.upper()):.10f}]')
        print(f'  λ*·k = 4 边界: {"< 4 ✓" if mw.upper() < 4 else "> 4 ✗"}')
