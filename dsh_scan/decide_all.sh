#!/bin/bash
# 决定性判定: 对每个 k, A = J - (4/k)I 正定? (M < 4?)
for k in 44 45 46 47 48 49 50; do
  (timeout 5400 python3 -u -c "
import sys, time, pickle
sys.path.insert(0, '.')
from flint import fmpq_mat, fmpq
from ldl_fast import ldl_sign_fast
with open('frac_cache_${k}_20.pkl','rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
Jf = fmpq_mat(n, n)
t0 = time.time()
for i in range(n):
    for j in range(n):
        Jf[i,j] = fmpq(J1[i][j].numerator, J1[i][j].denominator)
print(f'k=${k} convert {time.time()-t0:.0f}s', flush=True)
t1 = time.time()
pv = ldl_sign_fast(Jf, fmpq(4, ${k}))
print(f'k=${k} n={n} mid=4/${k}: LDL {time.time()-t1:.0f}s', flush=True)
if pv is None:
    print(f'k=${k}: ZERO PIVOT', flush=True)
else:
    print(f'k=${k}: M < 4 ? {all(pv)}  (pos pivots {sum(pv)}/{n})', flush=True)
" > decide_k${k}.log 2>&1) &
done
wait
echo ALL_DONE
