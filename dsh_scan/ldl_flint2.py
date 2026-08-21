"""flint 向量化 LDL^T 符号判定 (C 级矩阵乘, n=900 约 15-30s/迭代)"""
from flint import fmpq_mat, fmpq

def ldl_sign_flint_vec(A, mid=None):
    """A: fmpq_mat (对称); mid: fmpq
    返回 pivots (True=正) 或 None (零枢轴)"""
    n = A.nrows()
    if mid is not None:
        Am = fmpq_mat(n, n)
        for i in range(n):
            for j in range(n):
                Am[i, j] = A[i, j] - (mid if i == j else fmpq(0))
    else:
        Am = A
    D = [fmpq(0)] * n
    pivots = []
    for j in range(n):
        # v = A[j][j] - L[j,:j] D[:j] L[j,:j]^T
        v = fmpq(Am[j, j])
        if j > 0:
            lj = fmpq_mat(1, j)
            for m in range(j):
                lj[0, m] = Lrow[m]
            # lj @ diag(D[:j]) @ lj^T
            # 构造 d 向量: lj * diag = 逐元素乘
            rowd = fmpq_mat(1, j)
            for m in range(j):
                rowd[0, m] = Lrow[m] * D[m]
            s = (rowd * lj.transpose())[0, 0]
            v -= s
        if v == 0:
            return None
        D[j] = v
        pivots.append(v > 0)
        # L[i][j] = (A[i][j] - L[i,:j] D[:j] L[j,:j]^T) / D[j]  for i > j
        Lrow = [fmpq(0)] * n
        Lrow[j] = fmpq(1)
        if j < n - 1:
            # 列向量计算: col = A[j+1:, j] - L[j+1:, :j] @ (D[:j] * L[j, :j])
            # 用矩阵乘: Lsub (n-j-1 x j) @ diagvec (j x 1)
            if j > 0:
                Lsub = fmpq_mat(n - j - 1, j)
                for i in range(j + 1, n):
                    for m in range(j):
                        Lsub[i - j - 1, m] = Lall[i][m]
                dvec = fmpq_mat(j, 1)
                for m in range(j):
                    dvec[m, 0] = D[m] * Lrowj[m]
                prod = Lsub * dvec
            for i in range(j + 1, n):
                val = fmpq(Am[i, j])
                if j > 0:
                    val -= prod[i - j - 1, 0]
                val /= v
                Lrow[i] = val
                Lall[i][j] = val
        Lrowj = Lrow
    return pivots
