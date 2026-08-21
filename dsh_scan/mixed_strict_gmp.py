#!/usr/bin/env python3
"""mixed_strict_gmp.py — gmpy2.mpq 加速的严格 LDL^T 二分
用法: python3 mixed_strict_gmp.py k D eps_num eps_den [iters]
"""
import sys, time, pickle
import gmpy2
from gmpy2 import mpq

def ldl_sign_gmp(A):
    """LDL^T 惯性 (mpq), 返回枢轴符号列表或 None (零枢轴)"""
    n = len(A)
    D = [mpq(0)] * n
    L = [[mpq(0)] * n for _ in range(n)]
    pivots = []
    for j in range(n):
        v = A[j][j] - sum(L[j][m] * L[j][m] * D[m] for m in range(j))
        if v == 0:
            return None
        D[j] = v
        pivots.append(v > 0)
        L[j][j] = mpq(1)
        for i in range(j + 1, n):
            L[i][j] = (A[i][j] - sum(L[i][m] * L[j][m] * D[m] for m in range(j))) / D[j]
    return pivots

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    en = int(sys.argv[3]); ed = int(sys.argv[4])
    iters = int(sys.argv[5]) if len(sys.argv) > 5 else 25
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    # 转 mpq
    t1 = time.time()
    Im = [[mpq(x.numerator, x.denominator) for x in row] for row in I]
    Jm = [[mpq(x.numerator, x.denominator) for x in row] for row in J1]
    print(f"k={k} D={D} n={n} mpq conversion {time.time()-t1:.0f}s", flush=True)
    lo = mpq(0)
    hi = mpq(4, k)
    for it in range(iters):
        mid = (lo + hi) / 2
        t2 = time.time()
        Am = [[Jm[i][j] - mid * Im[i][j] for j in range(n)] for i in range(n)]
        pv = ldl_sign_gmp(Am)
        if pv is None:
            lo = hi = mid
            print(f"  iter {it}: zero-pivot at {gmpy2.mpfr(mid):.9f}", flush=True)
            break
        if any(pv):
            lo = mid
        else:
            hi = mid
        print(f"  iter {it}: lambda in ({gmpy2.mpfr(lo):.9f}, {gmpy2.mpfr(hi):.9f}) ({time.time()-t2:.0f}s)", flush=True)
    print(f"RESULT k={k} D={D}: lambda_max in ({gmpy2.mpfr(lo):.12f}, {gmpy2.mpfr(hi):.12f})  "
          f"M in ({float(k * gmpy2.mpfr(lo)):.8f}, {float(k * gmpy2.mpfr(hi)):.8f})  (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
