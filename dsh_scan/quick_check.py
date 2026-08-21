import sys, math
sys.path.insert(0, '.')
from collections import Counter
from m_scan import gen_even_partitions, all_partitions, multinom_terms, m_integral_Rk, merge_c

k, D = 2, 4
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
print("basis:", basis)
for i, (a, alpha) in enumerate(basis):
    e = expand(a, alpha)
    print(f"b[{i}] (1-P1)^{a} m_{alpha} = ", {kk: round(w,6) for kk, w in e.items() if w != 0})
b1 = expand(1, ())
s = 0.0
for kA, wA in b1.items():
    for kB, wB in b1.items():
        c, mG = merge_c(Counter(kA), Counter(kB))
        s += wA * wB * c * m_integral_Rk(mG, k)
print(f"M1[(1-P1)m_(), (1-P1)m_()] code={s:.8f} expected=1/12={1/12:.8f}")
b2 = expand(0, (2,))
s2 = 0.0
for kA, wA in b1.items():
    for kB, wB in b2.items():
        c, mG = merge_c(Counter(kA), Counter(kB))
        s2 += wA * wB * c * m_integral_Rk(mG, k)
print(f"M1[(1-P1)m_(), m_(2)] code={s2:.8f} expected=1/30={1/30:.8f}")
