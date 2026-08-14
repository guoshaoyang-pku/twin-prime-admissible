"""族内 λ_max(J1, I) 的有理数二分（严格区间）：LDL^T 惯性 + 二分"""
import sys, math
sys.path.insert(0, '.')
import importlib.util
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
from fractions import Fraction as Fr

def has_pos_eig(A):
    piv = s.ldl_sign(A)
    if piv is None:
        return None  # 零枢轴：λ 恰为特征值
    return any(piv)

def bisect_lambda(I, J1, lo, hi, iters=60):
    """λ_max ∈ (lo, hi) 的严格二分。返回 (区间下界, 区间上界) 有理数"""
    n = len(I)
    for _ in range(iters):
        mid = (lo + hi) / 2
        A = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
        r = has_pos_eig(A)
        if r is None:
            return mid, mid  # 恰为特征值
        if r:
            lo = mid
        else:
            hi = mid
    return lo, hi

def main():
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    D = int(sys.argv[4]); P = int(sys.argv[5]); r = int(sys.argv[6]) if len(sys.argv) > 6 else 6
    iters = int(sys.argv[7]) if len(sys.argv) > 7 else 55
    eps = Fr(en, ed)
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    H_cache = {}
    for coords in (k, k-1):
        for key in s.gen_multisets(2*D, 2*D):
            s.H_of(list(key), coords, H_cache)
    I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
    n = len(basis)
    lo, hi = bisect_lambda(I, J1, Fr(0), Fr(4, k), iters)
    print(f"k={k} eps={eps} D={D} n={n}: λ_max ∈ ({float(lo):.12f}, {float(hi):.12f})  M ∈ ({float(k*lo):.10f}, {float(k*hi):.10f})")

if __name__ == "__main__":
    main()
