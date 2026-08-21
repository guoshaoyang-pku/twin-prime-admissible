"""高效严格判定: J1 - mid*I 的正定性 via 整数化 + fmpz_mat.fflu (Bareiss)
合同变换 (对角缩放) 保持惯性; fflu 主元符号 = 顺序主子式符号"""
import math, pickle, time
from fractions import Fraction as Fr
from flint import fmpz_mat

def load_frac(k, D):
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    return I, J1

def is_positive_definite(I, J1, mid):
    """A = J1 - mid*I 正定? (mid: Fraction)"""
    n = len(I)
    # 行公分母
    l = [1] * n
    for i in range(n):
        lc = 1
        for j in range(n):
            d = (J1[i][j] - mid * I[i][j]).denominator
            lc = lc * d // math.gcd(lc, d)
        l[i] = lc
    # 整数矩阵 A'[i][j] = A[i][j] * l[i] * l[j]
    Az = fmpz_mat(n, n)
    for i in range(n):
        li = l[i]
        for j in range(n):
            a = (J1[i][j] - mid * I[i][j]) * (li * l[j])
            Az[i, j] = a.numerator  # 整数 (分母整除)
    # Bareiss LU: 无交换 + U 对角全正 ⟺ 正定
    perm, L, U, den = Az.fflu()
    # perm 恒等?
    for i in range(n):
        if perm[i, 0] != i:
            return False  # 有交换 → 非正定 (或零主元)
    for i in range(n):
        if U[i, i] <= 0:
            return False
    return True

def bisect(k, D, eps_num, eps_den, iters):
    I, J1 = load_frac(k, D)
    n = len(I)
    eps = Fr(eps_num, eps_den)
    print(f"k={k} D={D} n={n} eps={eps}", flush=True)
    lo = Fr(0)
    hi = Fr(4, k)  # λ_max ≤ 4/k (M=k·λ ≤ 4 的解析上界)
    for it in range(iters):
        mid = (lo + hi) / 2
        t1 = time.time()
        pd = is_positive_definite(I, J1, mid)
        dt = time.time() - t1
        if pd:
            hi = mid
        else:
            lo = mid
        print(f"  iter {it}: M in ({float(k*lo):.8f}, {float(k*hi):.8f}) [{dt:.0f}s]", flush=True)
    print(f"RESULT k={k}: M in ({float(k*lo):.10f}, {float(k*hi):.10f})", flush=True)

if __name__ == "__main__":
    import sys
    k, D = int(sys.argv[1]), int(sys.argv[2])
    iters = int(sys.argv[3]) if len(sys.argv) > 3 else 30
    bisect(k, D, 0, 1, iters)
