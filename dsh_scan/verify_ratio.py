#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""严格验证: 给定 Fraction 矩阵 I, J1 与近似特征向量 a (float),
做有理数逼近 a' 并精确验证 a'^T J1 a' / a'^T I a' > C (有理数不等式)。
用法: 由 fraction_mixed 内部调用 (发现 M > C 后)。
"""
from fractions import Fraction as Fr

def rationalize(v, denom=10**6):
    """float 向量 → 有理向量 (分母 denom)"""
    return [Fr(round(x * denom), denom) for x in v]

def verify(I, J1, a_rat, C):
    """精确验证 a^T J a / a^T I a > C"""
    n = len(a_rat)
    num = Fr(0)
    den = Fr(0)
    for i in range(n):
        for j in range(n):
            num += a_rat[i] * J1[i][j] * a_rat[j]
            den += a_rat[i] * I[i][j] * a_rat[j]
    ratio = num / den
    ok = ratio > C
    return ok, ratio, num, den
