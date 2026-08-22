"""严格判定: M_{k} < 4 ?  (混合基 ε=0, gmpy2 精确 LDL)
A = (4/k)*I - J1 正定 ⟺ lambda_max < 4/k ⟺ M < 4"""
import sys, time, pickle
sys.path.insert(0, '.')
from ldl_gmpy import ldl_sign_gmpy

k = int(sys.argv[1])
with open(f'frac_cache_{k}_20.pkl', 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
t0 = time.time()
pv = ldl_sign_gmpy(J1, I, 4, k)
dt = time.time() - t0
print(f'k={k} n={n} LDL(gmpy2) {dt:.0f}s', flush=True)
if pv is None:
    print(f'k={k}: ZERO PIVOT (M 恰等于 4 的概率极低)', flush=True)
else:
    print(f'k={k}: M < 4 STRICT ? {all(pv)}  (positive pivots {sum(pv)}/{n})', flush=True)
    # 进一步: 二分精化上界 (若 M<4, 找 M 的严格上界)
    if all(pv):
        lo, hi = 0, 4  # M 在 (lo, hi]
        for it in range(6):
            mid = (lo + hi) / 2
            pv2 = ldl_sign_gmpy(J1, I, mid.numerator, mid.denominator)
            if pv2 is None:
                break
            if all(pv2):
                hi = mid
            else:
                lo = mid
        print(f'k={k}: STRICT M < {hi:.6f}', flush=True)
