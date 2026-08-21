#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""rayleigh_check.py — 精确 Rayleigh 验证: M_{k,ε} > 4 的严格机器证明
流程:
  1. 载入 frac_cache_{k}_{D}_e{en}_{ed}.pkl (I, J1 精确有理)
  2. 精确有理对角合同变换: D' = diag(1/round(sqrt(I_ii))),  I'=D'ID', J'=D'J1D'
     (广义特征值不变; I' 良态 → 特征向量分量均衡)
  3. 浮点广义特征向量 y (numpy) 有理化 a' = round(y·Q)/Q
  4. 精确 num = a'ᵀJ'a', den = a'ᵀI'a' (mpq), 验证 k·num - 4·den > 0
  5. 失败时: 精确幂迭代 (LU(I') 一次, 反幂迭代若干步) 再验证
  6. 成功 ⇒ 原坐标系数 a = D'a' 使 M_{k,ε} ≥ k·num/den > 4 严格 ⇒ DHL[k,2] ⇒ H ≤ H(k)
用法: python3 rayleigh_check.py k D en ed [Qmax_digits] [power_steps]
"""
import sys, time, pickle
import gmpy2
from gmpy2 import mpq, mpfr

def exact_power_iter(I, J, a, steps):
    """精确广义幂迭代: a ← solve(I, J·a), 每次返回新 Rayleigh"""
    n = len(I)
    # 精确 LU (no pivoting; I 正定)
    LU = [[mpq(0)] * n for _ in range(n)]
    for i in range(n):
        LU[i][i] = I[i][i] - sum(LU[i][m] * LU[m][i] for m in range(i))
        for j in range(i + 1, n):
            LU[i][j] = I[i][j] - sum(LU[i][m] * LU[m][j] for m in range(i))
            LU[j][i] = (I[j][i] - sum(LU[j][m] * LU[m][i] for m in range(i))) / LU[i][i]
    def solve(b):
        y = [mpq(0)] * n
        for i in range(n):
            y[i] = b[i] - sum(LU[i][m] * y[m] for m in range(i))
        x = [mpq(0)] * n
        for i in range(n - 1, -1, -1):
            x[i] = (y[i] - sum(LU[i][m] * x[m] for m in range(i + 1, n))) / LU[i][i]
        return x
    for st in range(steps):
        Ja = [sum(J[i][j] * a[j] for j in range(n)) for i in range(n)]
        a = solve(Ja)
    return a, LU, solve

def rayleigh(I, J, a):
    n = len(I)
    Ja = [sum(J[i][j] * a[j] for j in range(n)) for i in range(n)]
    Ia = [sum(I[i][j] * a[j] for j in range(n)) for i in range(n)]
    num = sum(a[i] * Ja[i] for i in range(n))
    den = sum(a[i] * Ia[i] for i in range(n))
    return num, den

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    en = int(sys.argv[3]); ed = int(sys.argv[4])
    qdigits = int(sys.argv[5]) if len(sys.argv) > 5 else 6
    psteps = int(sys.argv[6]) if len(sys.argv) > 6 else 3
    fn = f'frac_cache_{k}_{D}_e{en}_{ed}.pkl'
    with open(fn, 'rb') as f:
        IF, J1F = pickle.load(f)
    n = len(IF)
    print(f"loaded {fn}: n={n}", flush=True)
    t1 = time.time()
    # 精确有理对角合同 (整数分母)
    diag = [mpq(x.numerator, x.denominator) for x in (IF[i][i] for i in range(n))]
    import math
    dd = [mpq(int(round(1.0 / math.sqrt(float(dg)))), 1) for dg in diag]
    I = [[dd[i] * mpq(IF[i][j].numerator, IF[i][j].denominator) * dd[j] for j in range(n)] for i in range(n)]
    J = [[dd[i] * mpq(J1F[i][j].numerator, J1F[i][j].denominator) * dd[j] for j in range(n)] for i in range(n)]
    del IF, J1F
    print(f"scaled exact pair ready ({time.time()-t1:.0f}s)", flush=True)
    # 浮点候选特征向量 (jittered Cholesky; I' 病态时加小扰动, 仅作幂迭代起点)
    import numpy as np
    Ifl = np.array([[float(x) for x in row] for row in I])
    Jfl = np.array([[float(x) for x in row] for row in J])
    got_float = False
    try:
        Lc = np.linalg.cholesky(Ifl)
    except np.linalg.LinAlgError:
        Lc = np.linalg.cholesky(Ifl + 1e-12 * np.eye(n))
    Lci = np.linalg.solve(Lc, np.eye(n))
    B = Lci @ Jfl @ Lci.T
    ev, V = np.linalg.eigh(B)
    lam_float = float(ev[-1])
    print(f"float lambda_max = {lam_float:.10f}  M_float = {k*lam_float:.8f} ({time.time()-t1:.0f}s)", flush=True)
    y = Lci.T @ V[:, -1]
    yf = [float(x) for x in y]
    ymax = max(abs(x) for x in yf)
    y = Lci.T @ V[:, -1]
    yf = [float(x) for x in y]
    ymax = max(abs(x) for x in yf)
    # 逐级有理化
    success = None
    for qd in range(4, qdigits + 1):
        Q = 10 ** qd
        a = [mpq(int(round(x / ymax * Q)), Q) for x in yf]
        num, den = rayleigh(I, J, a)
        val = k * num - 4 * den
        Mq = k * num / den
        print(f"Q=1e{qd}: M_Rayleigh = {float(mpfr(Mq)):.10f}  k·num-4·den = {float(mpfr(val)):.3e} ({time.time()-t1:.0f}s)", flush=True)
        if val > 0:
            success = (a, num, den, val, Mq, qd)
            break
    # 幂迭代精修 (每步都做精确 Rayleigh 检查, 成功即停)
    if success is None:
        print("rounding failed, exact power iteration...", flush=True)
        a = [mpq(int(round(x / ymax * 10 ** qdigits)), 10 ** qdigits) for x in yf]
        try:
            a2, LU, solve = exact_power_iter(I, J, a, 1)
            for st in range(1, psteps + 1):
                num, den = rayleigh(I, J, a2)
                val = k * num - 4 * den
                Mq = k * num / den
                print(f"  iter {st}: M_Rayleigh = {float(mpfr(Mq)):.10f}  k·num-4·den = {float(mpfr(val)):.3e}", flush=True)
                if val > 0:
                    success = (a2, num, den, val, Mq, qdigits)
                    break
                Ja = [sum(J[i][j] * a2[j] for j in range(n)) for i in range(n)]
                a2 = solve(Ja)
        except Exception as ex:
            print(f"power iteration error: {ex}", flush=True)
    if success is None:
        print("RAYLEIGH FAILED: 无候选向量给出 >4 的严格比值", flush=True)
        return 1
    a, num, den, val, Mq, qd = success
    print(f"★ SUCCESS: M_{{{k},{en}/{ed}}} >= {float(mpfr(Mq)):.10f} > 4  (Q=1e{qd})", flush=True)
    print(f"  严格验证: k·(aᵀJ1a) - 4·(aᵀIa) = {val} > 0  (精确有理数)", flush=True)
    # 原坐标系数 a_orig = D'·a
    a_orig = [dd[i] * a[i] for i in range(n)]
    import json
    out = {
        'k': k, 'D': D, 'eps': f'{en}/{ed}', 'n': n,
        'Q': 10 ** qd,
        'coeffs_scaled': [str(x) for x in a],
        'coeffs_original': [str(x) for x in a_orig],
        'num': str(num), 'den': str(den),
        'M_lower': str(Mq),
        'check_positive': str(val),
    }
    with open(f'rayleigh_win_{k}_{D}_e{en}_{ed}.json', 'w') as f:
        json.dump(out, f, indent=1)
    print(f"saved rayleigh_win_{k}_{D}_e{en}_{ed}.json", flush=True)
    return 0

if __name__ == '__main__':
    sys.exit(main())
