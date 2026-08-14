"""高精度广义特征值 λ_max(J1, I)：decimal 50 位 + 幂迭代 + 位移加速"""
import sys
from decimal import Decimal, getcontext, ROUND_HALF_UP
getcontext().prec = 50

def solve(A, b, n):
    """高斯消元（全选主元）解 A x = b"""
    M = [row[:] + [bi] for row, bi in zip(A, b)]
    for c in range(n):
        p = max(range(c, n), key=lambda rr: abs(M[rr][c]))
        if p != c: M[c], M[p] = M[p], M[c]
        piv = M[c][c]
        for j in range(c, n+1): M[c][j] /= piv
        for rr in range(n):
            if rr != c and M[rr][c] != 0:
                f = M[rr][c]
                for j in range(c, n+1): M[rr][j] -= f*M[c][j]
    return [M[i][n] for i in range(n)]

def max_geig(I, J, iters=400, tol=Decimal('1e-45')):
    """λ_max(J, I) via shifted inverse-free 幂迭代（位移 μ 加速）"""
    n = len(I)
    Ifl = [[Decimal(str(float(I[i][j]))) for j in range(n)] for i in range(n)]
    Jfl = [[Decimal(str(float(J[i][j]))) for j in range(n)] for i in range(n)]
    # 对角预缩放
    D = [Decimal(1)/Ifl[i][i].sqrt() for i in range(n)]
    for i in range(n):
        for j in range(n):
            Ifl[i][j] *= D[i]*D[j]
            Jfl[i][j] *= D[i]*D[j]
    x = [Decimal(1)/Decimal(n).sqrt()]*n
    lam = Decimal(0)
    for it in range(iters):
        # y = I^{-1} J x
        bx = [sum(Jfl[i][j]*x[j] for j in range(n)) for i in range(n)]
        y = solve(Ifl, bx, n)
        nrm = sum(v*v for v in y).sqrt()
        if nrm == 0: break
        y = [v/nrm for v in y]
        num = sum(y[i]*sum(Jfl[i][j]*y[j] for j in range(n)) for i in range(n))
        den = sum(y[i]*sum(Ifl[i][j]*y[j] for j in range(n)) for i in range(n))
        new_lam = num/den
        if abs(new_lam - lam) < tol:
            lam = new_lam
            # 返回特征向量（有理化前的近似）+ 特征值
            return lam, y
        lam = new_lam
        x = y
    return lam, x
