"""单 k 决定性判定: A = J - (4/k)I 的 LDL 主元符号 → M < 4?"""
import sys, time, pickle
sys.path.insert(0, '.')
from flint import fmpq_mat, fmpq
from ldl_fast import ldl_sign_fast

k = int(sys.argv[1])
with open(f'frac_cache_{k}_20.pkl', 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
Jf = fmpq_mat(n, n)
t0 = time.time()
for i in range(n):
    for j in range(n):
        Jf[i, j] = fmpq(J1[i][j].numerator, J1[i][j].denominator)
print(f'k={k} convert {time.time()-t0:.0f}s', flush=True)
t1 = time.time()
pv = ldl_sign_fast(Jf, fmpq(4, k))
print(f'k={k} n={n} mid=4/{k}: LDL {time.time()-t1:.0f}s', flush=True)
if pv is None:
    print(f'k={k}: ZERO PIVOT', flush=True)
else:
    print(f'k={k}: M < 4 ? {all(pv)}  (pos {sum(pv)}/{n})', flush=True)
