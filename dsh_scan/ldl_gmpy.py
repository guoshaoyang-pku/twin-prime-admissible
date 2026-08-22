"""gmpy2 加速的精确 LDL^T 符号判定 (C 级 mpq, 比 Python Fraction 快 20-50x)"""
import gmpy2
from gmpy2 import mpq

def ldl_sign_gmpy(J1, I, mid_num, mid_den):
    """判定 A = J1 - (mid_num/mid_den)*I 的 LDL 主元: 全负 ⟺ λ_max < mid (M < 4)
    J1, I: Fraction 矩阵; 返回 pivots 或 None"""
    n = len(J1)
    mid = mpq(mid_num, mid_den)
    D = [mpq(0)] * n
    L = [[mpq(0)] * n for _ in range(n)]
    pivots = []
    for j in range(n):
        v = mid * mpq(I[j][j].numerator, I[j][j].denominator) - mpq(J1[j][j].numerator, J1[j][j].denominator)
        for m in range(j):
            Ljm = L[j][m]
            v -= Ljm * D[m] * Ljm
        if v == 0:
            return None
        D[j] = v
        pivots.append(v > 0)
        L[j][j] = mpq(1)
        for i in range(j + 1, n):
            s = mid * mpq(I[i][j].numerator, I[i][j].denominator) - mpq(J1[i][j].numerator, J1[i][j].denominator)
            for m in range(j):
                s -= L[i][m] * D[m] * L[j][m]
            L[i][j] = s / v
    return pivots
