import sys, math
sys.path.insert(0, '.')
from collections import Counter
import numpy as np
from m_scan import gen_even_partitions, all_partitions, multinom_terms, m_integral_Rk, merge_c

def simpson(f, a, b, N=2000):
    if b <= a: return 0.0
    h = (b - a) / N
    s = f(a) + f(b)
    for i in range(1, N):
        s += (4.0 if i % 2 else 2.0) * f(a + i * h)
    return s * h / 3.0

k = 2; D = 4
PART = all_partitions(D)
parts = gen_even_partitions(D)
basis = []
for alpha in parts:
    for a in range(0, D - sum(alpha) + 1):
        if len(alpha) + a <= k:
            basis.append((a, alpha))
def expand(a, alpha):
    tmap = {}
    for kk in range(a + 1):
        w = math.comb(a, kk) * ((-1) ** kk)
        for coef, rho in multinom_terms(kk, PART):
            c, mG = merge_c(rho, Counter(alpha))
            key = tuple(sorted(mG.elements()))
            tmap[key] = tmap.get(key, 0.0) + w * coef * c
    return tmap
def bval(a, alpha, t1, t2):
    s = 1.0 - t1 - t2
    if s < 0: return 0.0
    tot = 0.0
    for key, w in expand(a, alpha).items():
        if w == 0: continue
        # m_key(t1,t2) = Σ 不同排列
        m = 0.0
        vals = list(key)
        if len(vals) == 0: m = 1.0
        elif len(vals) == 1: m = t1**vals[0] + t2**vals[0]
        elif len(vals) == 2: m = (t1**vals[0])*(t2**vals[1]) + (t1**vals[1])*(t2**vals[0])
        else: m = 0.0
        tot += w * m
    return s ** a * tot if False else tot  # b = (1-P1)^a m_alpha 已展开, 无需乘

for i in range(len(basis)):
    for j in range(i, len(basis)):
        a1, al1 = basis[i]; a2, al2 = basis[j]
        def f1(t1): 
            def f2(t2): return bval(a1, al1, t1, t2) * bval(a2, al2, t1, t2)
            return simpson(f2, 0.0, 1.0 - t1)
        num = simpson(f1, 0.0, 1.0)
        s = 0.0
        for kA, wA in expand(a1, al1).items():
            for kB, wB in expand(a2, al2).items():
                c, mG = merge_c(Counter(kA), Counter(kB))
                s += wA * wB * c * m_integral_Rk(mG, k)
        if abs(num - s) > 1e-6:
            print(f"b[{i}]({a1},{al1}) × b[{j}]({a2},{al2}): num={num:.8f} closed={s:.8f} DIFF={num-s:.2e}")
