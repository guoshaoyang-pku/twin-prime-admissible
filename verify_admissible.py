#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""独立验证器：用与 admissible.c 完全不同的算法（直接暴力检查每个素数 p <= k
的剩余类覆盖情况）验证给定 k 元组是否可容许。用法:
    python3 verify_admissible.py "0,2,6,8,12"
"""
import sys


def is_prime(n):
    if n < 2:
        return False
    i = 2
    while i * i <= n:
        if n % i == 0:
            return False
        i += 1
    return True


def admissible(tup):
    k = len(tup)
    for p in range(2, k + 1):
        if not is_prime(p):
            continue
        residues = {v % p for v in tup}
        if len(residues) == p:
            return False, p  # 覆盖了模 p 的全部剩余类
    return True, None


if __name__ == "__main__":
    tup = [int(x) for x in sys.argv[1].split(",")]
    ok, p = admissible(tup)
    d = max(tup) - min(tup)
    print(f"tuple size k={len(tup)}, diameter d={d}")
    if ok:
        print("ADMISSIBLE: 通过（对每个素数 p<=k 都未覆盖全部剩余类）")
    else:
        print(f"NOT ADMISSIBLE: 模 {p} 覆盖了全部剩余类")
