"""flint 向量化 LDL^T 符号判定 v3 (完整 L 矩阵维护)"""
from flint import fmpq_mat, fmpq

def ldl_sign_flint3(A, mid=None):
    n = A.nrows()
    if mid is not None:
        Am = fmpq_mat(n, n)
        for i in range(n):
            for j in range(n):
                Am[i, j] = A[i, j] - (mid if i == j else fmpq(0))
    else:
        Am = A
    L = fmpq_mat(n, n)  # 初始 0
    for i in range(n):
        L[i, i] = fmpq(1)
    D = [fmpq(0)] * n
    pivots = []
    for j in range(n):
        # v = Am[j][j] - (L[j, :j] * D[:j]) · L[j, :j]^T
        v = fmpq(Am[j, j])
        if j > 0:
            row = fmpq_mat(1, j)
            for m in range(j):
                row[0, m] = L[j, m] * D[m]
            v -= (row * L[j, :j].transpose())[0, 0] if False else _dot(L, j, D)
        if v == 0:
            return None
        D[j] = v
        pivots.append(v > 0)
        if j < n - 1:
            # col = Am[j+1:, j] - L[j+1:, :j] @ (D[:j] * L[j, :j])
            col = fmpq_mat(n - j - 1, 1)
            for i in range(j + 1, n):
                val = fmpq(Am[i, j])
                if j > 0:
                    acc = fmpq(0)
                    for m in range(j):
                        acc += L[i, m] * D[m] * L[j, m]
                    val -= acc
                col[i - j - 1, 0] = val / v
            for i in range(j + 1, n):
                L[i, j] = col[i - j - 1, 0]
    return pivots

def _dot(L, j, D):
    acc = fmpq(0)
    for m in range(j):
        acc += L[j, m] * D[m] * L[j, m]
    return acc
