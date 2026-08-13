#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Count twin primes up to N (simple odd-only sieve), compare with the
Hardy-Littlewood prediction  pi2(N) ~ 2*C2*N/(log N)^2,  C2 = 0.6601618158...
"""
import sys
import time
import math

C2 = 0.660161815846869573927812110014


def count_twins(N):
    t0 = time.time()
    if N < 5:
        return 0
    # odd-only sieve: index i represents the number 2*i+1
    size = (N + 1) // 2
    bs = bytearray([1]) * size
    bs[0] = 0  # 1 is not prime
    r = math.isqrt(N)
    for i in range(3, r + 1, 2):
        if bs[i // 2]:
            start = (i * i) // 2  # index of i*i (odd), marking step i in index space
            bs[start::i] = b"\x00" * (((size - 1 - start) // i) + 1)
    cnt = 0
    # p and p+2 both prime, p odd
    for p in range(3, N - 1, 2):
        if bs[p // 2] and bs[(p + 2) // 2]:
            cnt += 1
    dt = time.time() - t0
    l = math.log(N)
    hl = 2 * C2 * N / (l * l)
    print(f"N = {N:,}")
    print(f"twin prime count pi2(N) = {cnt:,}")
    print(f"Hardy-Littlewood estimate = {hl:,.1f}")
    print(f"ratio count/estimate = {cnt / hl:.6f}")
    print(f"time = {dt:.2f} s")
    return cnt


if __name__ == "__main__":
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 100_000_000
    count_twins(N)
