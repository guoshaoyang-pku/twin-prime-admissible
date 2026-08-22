import sys, time, pickle
import numpy as np
import gmpy2
from gmpy2 import mpfr
sys.path.insert(0, '.')
import importlib.util
spec = importlib.util.spec_from_file_location("lf", "legendre_fix.py")
lf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lf)

k, D, bits = 49, 20, 512
with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
res = lf.reduce_pair(I, J1, bits)
assert res[0] != 'fail', res[1]
V, s, L, d = res
Jtf = np.array([[float(x) for x in row] for row in V])
ev = np.linalg.eigvalsh(Jtf)
lam = float(ev[-1])
wvec = np.linalg.eigh(Jtf)[1][:, -1]
print("λ* = %.15f" % lam, flush=True)
ctx = gmpy2.get_context(); ctx.precision = bits
Im = lf.to_mpfr(I, bits); Jm = lf.to_mpfr(J1, bits)
wm = [mpfr(float(x)) for x in wvec]
b = [s[i]*wm[i] for i in range(n)]
z = [mpfr(0)]*n
for i in range(n-1, -1, -1):
    zi = b[i]
    for m in range(i+1, n):
        zi -= L[m][i]*z[m]
    z[i] = zi
lam_m = mpfr(str(lam))
# 残差 r = (J1 - λ I) v; 报告 ||r||_2 与 ||v||_I
rn2 = mpfr(0); vI2 = mpfr(0)
for i in range(n):
    si = mpfr(0)
    for j in range(n):
        si += Jm[i][j]*z[j]
    sd = mpfr(0)
    for j in range(n):
        sd += Im[i][j]*z[j]
    ri = si - lam_m*sd
    rn2 += ri*ri
    vI2 += z[i]*sd
print("||(J1-λI)v||_2 = %.3e   ||v||_I = %.3e" % (float(gmpy2.sqrt(rn2)), float(gmpy2.sqrt(vI2))), flush=True)
# 相对残差
print("rel resid = %.3e" % float(gmpy2.sqrt(rn2)/gmpy2.sqrt(vI2)), flush=True)
# Ĩ = T I T^T 全矩阵检查: max|Ĩ - I| (抽 50 行)
maxres = 0.0
import random
random.seed(5)
for t in range(50):
    i = random.randrange(n); j = random.randrange(n)
    val = mpfr(0)
    for p in range(n):
        sp = mpfr(0)
        for q in range(n):
            sp += Linv_row_p[i][p] * Im[p][q] * Linv_row_p[j][q]  # placeholder
        val += sp
# 改为直接: Ĩ[i][j] = Σ_pq T[i][p] I[p][q] T[j][q], T = D^{-1/2} L^{-1}
# 需要 T — 从 L 和 s 计算行
def Trow(i):
    # T[i] = s[i] * L^{-1}[i,:] — L^{-1}[i,:] = e_i - Σ_{m<i} L[i][m] L^{-1}[m,:]
    # 用前代逐行求 L^{-1}: X[i][j] = δij - Σ_{m<i} L[i][m] X[m][j]
    return None
# 简化: 直接用已算好的关系 Ĩ 的第 i 行 = s[i]^2 * (L^{-1} I L^{-T}) 的第 i 行 — 改用 (T I) 与 (T^T) 直接乘
maxres = 0.0
for t in range(30):
    i = random.randrange(n); j = random.randrange(n)
    # (L^{-1} I)[i][q] 用前代: Y[i] = I[i] - Σ_{m<i} L[i][m] Y[m]
    # 一次算一行 Y_i (长度 n) 再与 L^{-1} 的第 j 行点乘 — 需要 L^{-1} 行
    # 直接双重循环 Σ_p Σ_q T[i][p] I[p][q] T[j][q]
    val = mpfr(0)
    for p in range(n):
        row_p = mpfr(0)
        # T[i][p] = s[i] * Linv[i][p]; 先求 Linv[i][*]: 前代解 L X = e_i
        # 前代: X[m] = δ[i][m] - Σ_{r<m} L[m][r] X[r]
        X = [mpfr(0)]*n
        for m in range(n):
            xm = mpfr(1) if m == i else mpfr(0)
            for r in range(m):
                xm -= L[m][r]*X[r]
            X[m] = xm
        Tip = s[i]*X[p]
        # T[j][q] 类似
        Xj = [mpfr(0)]*n
        for m in range(n):
            xm = mpfr(1) if m == j else mpfr(0)
            for r in range(m):
                xm -= L[m][r]*Xj[r]
            Xj[m] = xm
        sp = mpfr(0)
        for q in range(n):
            sp += Im[p][q]*(s[j]*Xj[q])
        val += Tip*sp
    r = abs(val - Im[i][j])
    maxres = max(maxres, float(r))
print("max|Ĩ - I| over 30 samples = %.3e" % maxres, flush=True)
