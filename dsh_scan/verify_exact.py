#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_exact.py — 严格有理数 Rayleigh 证书 (k=49 D=20 或任意缓存)

流程:
  1. legendre_fix.py 管线 (高精度 LDL^T + 约化) 得到 λ_max 与特征向量 v (原始基, mpfr);
  2. v 的每个分量 mpfr 是精确二进有理数 → gmpy2.mpq(v_i) 无损转成精确有理数;
  3. 在原始精确有理矩阵上计算 Rayleigh 商 RQ_exact = (v^T J1 v)/(v^T I v) (mpq 精确算术);
  4. 输出: RQ_exact 是 λ_max(J1, I) 的严格下界; 与 float64 λ_max 之差给出端到端误差。

用法: python3 verify_exact.py k D [bits=512]
"""
import sys, time, pickle
import numpy as np
import gmpy2
from gmpy2 import mpfr, mpq
sys.path.insert(0, '.')
import importlib.util
spec = importlib.util.spec_from_file_location("lf", "legendre_fix.py")
lf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lf)

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    bits = int(sys.argv[3]) if len(sys.argv) > 3 else 512
    cache = sys.argv[4] if len(sys.argv) > 4 else f'frac_cache_{k}_{D}.pkl'
    t0 = time.time()
    with open(cache, 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    print(f"k={k} D={D} n={n} bits={bits}", flush=True)
    res = lf.reduce_pair(I, J1, bits)
    assert res[0] != 'fail', res[1]
    V, s, L, d = res
    Jtf = np.array([[float(x) for x in row] for row in V])
    lam = float(np.linalg.eigvalsh(Jtf)[-1])
    wvec = np.linalg.eigh(Jtf)[1][:, -1]
    ctx = gmpy2.get_context(); old = ctx.precision; ctx.precision = bits
    wm = [mpfr(float(x)) for x in wvec]
    b = [s[i] * wm[i] for i in range(n)]
    z = [mpfr(0)] * n
    for i in range(n - 1, -1, -1):
        zi = b[i]
        for m in range(i + 1, n):
            zi -= L[m][i] * z[m]
        z[i] = zi
    ctx.precision = old
    print(f"λ_max (float64 of J̃) = {lam:.15f}  M = {k*lam:.10f}   (reduce {time.time()-t0:.0f}s)", flush=True)
    # 无损 mpfr -> mpq (mpfr 是精确二进有理数)
    zq = [mpq(x) for x in z]
    print(f"v 分量数量级: max|v| = {float(max(abs(float(x)) for x in z)):.3e}", flush=True)
    # 精确 Rayleigh: num = Σ_i v_i (J1 v)_i, den = Σ_i v_i (I v)_i
    t1 = time.time()
    num = mpq(0); den = mpq(0)
    for i in range(n):
        zi = zq[i]
        sn = mpq(0); sd = mpq(0)
        J1i = J1[i]; Ii = I[i]
        for j in range(n):
            sn += mpq(J1i[j].numerator, J1i[j].denominator) * zq[j]
            sd += mpq(Ii[j].numerator, Ii[j].denominator) * zq[j]
        num += zi * sn
        den += zi * sd
    RQ = num / den
    print(f"exact RQ(v) computed in {time.time()-t1:.0f}s", flush=True)
    rq_float = float(RQ)
    print(f"RQ_exact = {rq_float:.15f}   (严格下界: RQ ≤ λ_max)", flush=True)
    print(f"diff = λ_max - RQ_exact = {lam - rq_float:.3e}   (端到端误差上界)", flush=True)
    print(f"k*RQ_exact = {k*rq_float:.10f}  (严格 M 下界)", flush=True)
    print(f"CERT k={k} D={D}: λ_max = {lam:.15f} (±{lam-rq_float:.1e}), RQ_exact = {rq_float:.15f}, M = {k*lam:.10f}", flush=True)

if __name__ == '__main__':
    main()
