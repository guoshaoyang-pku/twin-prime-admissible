#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""rayleigh_mpfr.py — 高精度浮点候选 + 精确 Rayleigh 验证 (大 n 快速路径)
流程:
  1. 载入 frac_cache_{k}_{D}_e{en}_{ed}.pkl (I, J1 精确有理)
  2. 精确有理对角合同 D'=diag(round(1/sqrt(I_ii))): I'=D'ID', J'=D'J1D' (广义特征值不变)
  3. gmpy2 mpfr (bits 精度) LU(I') + 幂迭代 → 高精度特征向量 w (良态基, 分量均衡)
  4. w 有理化 a = round(w·Q)/Q (Q=1e25), 精确 Rayleigh: k·num - 4·den > 0 ?
  5. 成功 ⇒ M_{k,ε} ≥ k·num/den > 4 严格
用法: python3 rayleigh_mpfr.py k D en ed [bits=512] [iters=40] [qdigits=25]
"""
import sys, time, pickle, math
import gmpy2
from gmpy2 import mpq, mpfr, mpz, get_context

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    en = int(sys.argv[3]); ed = int(sys.argv[4])
    bits = int(sys.argv[5]) if len(sys.argv) > 5 else 512
    iters = int(sys.argv[6]) if len(sys.argv) > 6 else 40
    qdigits = int(sys.argv[7]) if len(sys.argv) > 7 else 25
    get_context().precision = bits
    fn = f'frac_cache_{k}_{D}_e{en}_{ed}.pkl'
    if len(sys.argv) > 8:
        fn = sys.argv[8]
    with open(fn, 'rb') as f:
        IF, J1F = pickle.load(f)
    n = len(IF)
    print(f"loaded {fn}: n={n}, mpfr bits={bits}", flush=True)
    t1 = time.time()
    # 精确有理对角合同
    diag = [IF[i][i] for i in range(n)]
    dd = [mpq(int(round(1.0 / math.sqrt(float(mpq(dg.numerator, dg.denominator))))), 1) for dg in diag]
    # mpfr 矩阵
    def to_fr(x, di, dj):
        return mpfr(di) * mpfr(x.numerator) * mpfr(dj) / mpfr(x.denominator)
    I = [[to_fr(IF[i][j], dd[i], dd[j]) for j in range(n)] for i in range(n)]
    J = [[to_fr(J1F[i][j], dd[i], dd[j]) for j in range(n)] for i in range(n)]
    del IF, J1F
    IG = [row[:] for row in I]  # 保留原始 Gram (Rayleigh 内积用)
    print(f"mpfr matrices ready ({time.time()-t1:.0f}s)", flush=True)
    # mpfr LU (no pivot, 对称正定缩放)
    t2 = time.time()
    for i in range(n):
        piv = I[i][i] - sum(I[i][m] * I[m][i] for m in range(i))
        if piv == 0:
            print("zero pivot!", flush=True); return 1
        I[i][i] = piv
        for j in range(i + 1, n):
            I[j][i] = (I[j][i] - sum(I[j][m] * I[m][i] for m in range(i))) / piv
            I[i][j] = I[i][j] - sum(I[i][m] * I[m][j] for m in range(i))
    print(f"mpfr LU done ({time.time()-t2:.0f}s)", flush=True)
    def solve(b):
        y = [mpfr(0)] * n
        for i in range(n):
            y[i] = b[i] - sum(I[i][m] * y[m] for m in range(i))
        x = [mpfr(0)] * n
        for i in range(n - 1, -1, -1):
            x[i] = (y[i] - sum(I[i][m] * x[m] for m in range(i + 1, n))) / I[i][i]
        return x
    def matvec(M, v):
        return [sum(M[i][j] * v[j] for j in range(n)) for i in range(n)]
    def rayleigh_fr(v):
        Jv = matvec(J, v); Iv = matvec(IG, v)
        return sum(v[i] * Jv[i] for i in range(n)) / sum(v[i] * Iv[i] for i in range(n))
    # 初始: 浮点64特征向量 (jittered Cholesky) 作为起点, 加速收敛
    import numpy as np
    Ifl = np.array([[float(x) for x in row] for row in IG])
    Jfl = np.array([[float(x) for x in row] for row in J])
    try:
        Lc = np.linalg.cholesky(Ifl)
    except np.linalg.LinAlgError:
        Lc = np.linalg.cholesky(Ifl + 1e-11 * np.eye(n))
    Lci = np.linalg.solve(Lc, np.eye(n))
    B = Lci @ Jfl @ Lci.T
    ev, V = np.linalg.eigh(B)
    y = Lci.T @ V[:, -1]
    v = [mpfr(float(x)) for x in y]
    lam0 = rayleigh_fr(v)
    print(f"float start: M = {float(mpfr(k) * lam0):.8f} (float64 eig = {float(ev[-1]) * k:.8f})", flush=True)
    best = 0
    # 保留最近 3 个迭代向量 (mpfr)
    hist = []
    for it in range(iters):
        lam = rayleigh_fr(v)
        if it % 5 == 0 or it == iters - 1:
            print(f"  mpfr iter {it}: M = {float(mpfr(k) * lam):.10f}", flush=True)
        if lam > best:
            best = lam
        Jv = matvec(J, v)
        v = solve(Jv)
        # 归一化防溢出
        mx = max(abs(x) for x in v)
        if mx > 1:
            v = [x / mx for x in v]
        hist.append([x for x in v])
        if len(hist) > 3:
            hist.pop(0)
    lam = rayleigh_fr(v)
    print(f"mpfr final lambda = {float(mpfr(lam)):.12f}  M = {float(mpfr(k) * lam):.10f} ({time.time()-t1:.0f}s)", flush=True)
    # 精确 3 向量 Ritz: 取最后 3 个迭代向量有理化后做 3x3 精确广义特征
    cands = []
    for w in hist:
        wmax = max(abs(x) for x in w)
        if wmax == 0:
            continue
        cands.append([mpq(int(mpz(round(mpfr(x) / wmax * 10 ** (qdigits // 2)))), 10 ** (qdigits // 2)) for x in w])
    # 精确矩阵载入
    with open(fn, 'rb') as f:
        IF2, J1F2 = pickle.load(f)
    Im3 = [[dd[i] * IF2[i][j] * dd[j] for j in range(n)] for i in range(n)]
    Jm3 = [[dd[i] * J1F2[i][j] * dd[j] for j in range(n)] for i in range(n)]
    del IF2, J1F2
    def mm_quad(M, u, w):
        Mu = [sum(M[i][j] * u[j] for j in range(n)) for i in range(n)]
        return sum(u[i] * Mu[i] for i in range(n))
    a = None
    if cands:
        m3 = len(cands)
        G3 = [[mm_quad(Im3, cands[i], cands[j]) for j in range(m3)] for i in range(m3)]
        H3 = [[mm_quad(Jm3, cands[i], cands[j]) for j in range(m3)] for i in range(m3)]
        # 3x3 广义特征 (解析, 用 mpq 精确二分太贵; 直接枚举 Ritz 组合: 用浮点解再用精确 Rayleigh 挑最优)
        import itertools
        best_val = None
        # 浮点解 3x3 广义特征
        import numpy as np
        G3f = np.array([[float(x) for x in row] for row in G3])
        H3f = np.array([[float(x) for x in row] for row in H3])
        try:
            ev3, V3 = np.linalg.eigh(np.linalg.inv(G3f) @ H3f)
        except np.linalg.LinAlgError:
            ev3, V3 = np.linalg.eigh(np.linalg.pinv(G3f) @ H3f)
        c = V3[:, -1]
        csum = sum(abs(x) for x in c)
        if csum > 0:
            cd = [mpq(int(round(x / csum * 10 ** 8)), 10 ** 8) for x in c]
            aritz = [sum(cd[i] * cands[i][j] for i in range(m3)) for j in range(n)]
            num3 = mm_quad(Jm3, aritz, aritz)
            den3 = mm_quad(Im3, aritz, aritz)
            if den3 > 0:
                M3 = k * num3 / den3
                print(f"Ritz3: M = {float(mpfr(M3)):.12f}", flush=True)
                if best_val is None or M3 > best_val:
                    a, num, den = aritz, num3, den3
    # 有理化 + 精确 Rayleigh (Ritz 候选优先, 但仅当优于普通候选)
    Q = 10 ** qdigits
    vmax = max(abs(x) for x in v)
    if a is None:
        a = [mpq(int(mpz(round(mpfr(x) / vmax * Q))), Q) for x in v]
        # 重新载入精确矩阵 (mpq, 缩放基)
        with open(fn, 'rb') as f:
            IF2, J1F2 = pickle.load(f)
        Im = [[dd[i] * IF2[i][j] * dd[j] for j in range(n)] for i in range(n)]
        Jm = [[dd[i] * J1F2[i][j] * dd[j] for j in range(n)] for i in range(n)]
        del IF2, J1F2
        Ja = [sum(Jm[i][j] * a[j] for j in range(n)) for i in range(n)]
        Ia = [sum(Im[i][j] * a[j] for j in range(n)) for i in range(n)]
        num = sum(a[i] * Ja[i] for i in range(n))
        den = sum(a[i] * Ia[i] for i in range(n))
    else:
        # Ritz 候选: 与普通候选比较取优
        with open(fn, 'rb') as f:
            IF2, J1F2 = pickle.load(f)
        Im = [[dd[i] * IF2[i][j] * dd[j] for j in range(n)] for i in range(n)]
        Jm = [[dd[i] * J1F2[i][j] * dd[j] for j in range(n)] for i in range(n)]
        del IF2, J1F2
        a_plain = [mpq(int(mpz(round(mpfr(x) / vmax * Q))), Q) for x in v]
        Ja = [sum(Jm[i][j] * a_plain[j] for j in range(n)) for i in range(n)]
        Ia = [sum(Im[i][j] * a_plain[j] for j in range(n)) for i in range(n)]
        num_p = sum(a_plain[i] * Ja[i] for i in range(n))
        den_p = sum(a_plain[i] * Ia[i] for i in range(n))
        if k * num / den > k * num_p / den_p:
            pass
        else:
            a, num, den = a_plain, num_p, den_p
    val = k * num - 4 * den
    Mq = k * num / den
    print(f"exact Rayleigh: M = {float(mpfr(Mq)):.10f}  k·num-4·den = {float(mpfr(val)):.6e}", flush=True)
    if val > 0:
        print(f"★ SUCCESS: M_{{{k},{en}/{ed}}} >= {float(mpfr(Mq)):.10f} > 4", flush=True)
        import json
        a_orig = [dd[i] * a[i] for i in range(n)]
        out = {'k': k, 'D': D, 'eps': f'{en}/{ed}', 'n': n, 'Q': Q,
               'coeffs_original': [str(x) for x in a_orig],
               'num': str(num), 'den': str(den), 'M_lower': str(Mq),
               'check_positive': str(val)}
        with open(f'rayleigh_win_{k}_{D}_e{en}_{ed}.json', 'w') as f:
            json.dump(out, f, indent=1)
        print(f"saved rayleigh_win_{k}_{D}_e{en}_{ed}.json", flush=True)
        return 0
    print("RAYLEIGH FAILED (candidate < 4)", flush=True)
    return 1

if __name__ == '__main__':
    sys.exit(main())
