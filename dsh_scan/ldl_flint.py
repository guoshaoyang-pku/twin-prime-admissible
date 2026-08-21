"""flint 加速的精确 LDL^T 符号判定 (比 Python Fraction 快 20-100x)"""
from flint import fmpq_mat, fmpq

def ldl_sign_flint(A, mid=None):
    """A: fmpq_mat 对称; mid: fmpq (可选, 判定 A - mid*I 的 LDL 主元符号)
    返回 pivots 列表 (True=正) 或 None (零枢轴)"""
    n = A.nrows()
    if mid is not None:
        Am = [[A[i, j] - (mid if i == j else fmpq(0)) for j in range(n)] for i in range(n)]
    else:
        Am = [[A[i, j] for j in range(n)] for i in range(n)]
    D = [fmpq(0)] * n
    L = [[fmpq(0)] * n for _ in range(n)]
    pivots = []
    for j in range(n):
        v = Am[j][j]
        for m in range(j):
            v -= L[j][m] * L[j][m] * D[m]
        if v == 0:
            return None
        D[j] = v
        pivots.append(v > 0)
        L[j][j] = fmpq(1)
        for i in range(j + 1, n):
            s = Am[i][j]
            for m in range(j):
                s -= L[i][m] * L[j][m] * D[m]
            L[i][j] = s / D[j]
    return pivots
