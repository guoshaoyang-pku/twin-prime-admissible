"""严格判定: M_{k,eps=1/50}(混合基) < 4 ?  (gmpy2 精确 LDL)
A = (4/k)*I - J1 正定 ⟺ lambda_max < 4/k ⟺ M < 4
单次判定, 无二分. 读 frac_cache_{k}_20.pkl (当前为 eps=1/50 版本)."""
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
print(f'k={k} n={n} eps=1/50 LDL(gmpy2) {dt:.0f}s', flush=True)
if pv is None:
    print(f'k={k}: ZERO PIVOT (M 恰等于 4 的概率极低)', flush=True)
else:
    pos = sum(pv)
    print(f'k={k}: M < 4 STRICT ? {all(pv)}  (positive pivots {pos}/{n})', flush=True)
