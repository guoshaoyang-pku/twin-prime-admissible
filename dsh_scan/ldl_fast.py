"""优化 flint LDL: 局部变量 + 最小化对象创建"""
from flint import fmpq_mat, fmpq

def ldl_sign_fast(A, mid=None):
    n = A.nrows()
    if mid is not None:
        Am = fmpq_mat(n, n)
        for i in range(n):
            for j in range(n):
                Am[i, j] = A[i, j] - (mid if i == j else fmpq(0))
    else:
        Am = A
    L = fmpq_mat(n, n)
    for i in range(n):
        L[i, i] = fmpq(1)
    D = [fmpq(0)] * n
    pivots = []
    zero = fmpq(0)
    for j in range(n):
        v = Am[j, j]
        if j > 0:
            acc = zero
            for m in range(j):
                Ljm = L[j, m]
                acc -= Ljm * D[m] * Ljm
            v += acc
        if v == 0:
            return None
        D[j] = v
        pivots.append(v > 0)
        if j < n - 1:
            dj = v
            for i in range(j + 1, n):
                val = Am[i, j]
                if j > 0:
                    acc = zero
                    for m in range(j):
                        acc -= L[i, m] * D[m] * L[j, m]
                    val += acc
                L[i, j] = val / dj
    return pivots
