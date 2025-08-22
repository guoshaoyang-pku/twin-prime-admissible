#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""routeB_verify.py — 路线 B 证书独立验证器
输入: frac_cacheB_{k}_{DP}_{DM}_e{en}_{ed}.pkl (精确矩阵 I, J1, mpq)
      rayleigh_win_B_{k}_{DP}_{DM}_e{en}_{ed}.json (系数向量 a, num, den)
独立重算 a^T J1 a 与 a^T I a (不依赖原计算路径), 验证 k*num - 4*den > 0 精确成立。
用法: python3 routeB_verify.py k DP DM en ed
"""
import sys, json, pickle
from gmpy2 import mpq

def main():
    k, DP, DM = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
    en, ed = int(sys.argv[4]), int(sys.argv[5])
    fn = f'frac_cacheB_{k}_{DP}_{DM}_e{en}_{ed}.pkl'
    jfn = f'rayleigh_win_B_{k}_{DP}_{DM}_e{en}_{ed}.json'
    with open(fn, 'rb') as f:
        I, J1 = pickle.load(f)
    with open(jfn) as f:
        cert = json.load(f)
    n = len(I)
    a = [mpq(s) for s in cert['coeffs_original']]
    assert len(a) == n, f"coeff len {len(a)} != n {n}"
    num = mpq(0)
    den = mpq(0)
    for i in range(n):
        ja = mpq(0)
        ia = mpq(0)
        for j in range(n):
            ja += J1[i][j] * a[j]
            ia += I[i][j] * a[j]
        num += a[i] * ja
        den += a[i] * ia
    val = k * num - 4 * den
    print(f"独立重算: num = {num}")
    print(f"独立重算: den = {den}")
    print(f"k*num - 4*den = {val}")
    print(f"M = k*num/den = {float(mpq(k)*num/den):.12f}")
    ok = (val > 0) and (num == mpq(cert['num'])) and (den == mpq(cert['den']))
    print("★ 验证通过: M > 4 严格成立" if val > 0 else "✗ 验证失败: M ≤ 4")
    return 0 if val > 0 else 1

if __name__ == '__main__':
    sys.exit(main())
