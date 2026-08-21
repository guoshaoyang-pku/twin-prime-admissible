#!/usr/bin/env python3
"""k=2 公式验证 (一维 Simpson, 快)"""
import math, sys
sys.path.insert(0, '.')
import floatbuild as fb

def simpson(f, a, b, N=2000):
    if b <= a: return 0.0
    h = (b - a) / N
    s = f(a) + f(b)
    for i in range(1, N):
        s += (4.0 if i % 2 else 2.0) * f(a + i * h)
    return s * h / 3.0

def F_of(t, eps, r, gamma):
    s = 1.0 + eps - sum(t)
    if s <= 0: return 0.0
    p = 1.0
    for v in gamma:
        p *= sum(x ** v for x in t)
    return s ** r * p

def I_num(eps, r, gamma):
    def g(t2):
        def f(t1): return F_of((t1, t2), eps, r, gamma) ** 2
        return simpson(f, 0.0, 1.0 - t2)
    return simpson(g, 0.0, 1.0)

def J1_num(eps, r, gamma):
    def g(t2):
        def f(t1): return F_of((t1, t2), eps, r, gamma)
        return simpson(f, 0.0, 1.0 - t2) ** 2
    return simpson(g, 0.0, 1.0)

for (eps, r, gamma) in [(0.0, 1, (2,)), (0.0, 0, (2,)), (0.0, 1, (1,)), (0.0, 2, (2,)), (0.0, 1, ()), (0.25, 1, (2,))]:
    In = I_num(eps, r, gamma)
    Jn = J1_num(eps, r, gamma)
    g2 = tuple(sorted(gamma + gamma))
    Hc = {}
    In_closed = (1.0+eps)**(2 + 2*sum(gamma) + 2*r) * math.factorial(2*r) * fb.H_of_float(list(g2), 2, Hc) / math.factorial(2 + 2*r + 2*sum(gamma))
    H2 = {}
    for coords in (2, 1):
        fb.H_of_float(list(g2), coords, H2)
        fb.H_of_float(list(gamma), coords, H2)
    I, J1 = fb.build_matrices_float(2, eps, r, [gamma], H2)
    print(f"eps={eps} r={r} gamma={gamma}")
    print(f"  I: num={In:.8f} closed={In_closed:.8f} matrix={I[0][0]:.8f}  diff_closed={abs(In-In_closed):.2e} diff_matrix={abs(In-I[0][0]):.2e}")
    print(f"  J1: num={Jn:.8f} matrix={J1[0][0]:.8f}  diff={abs(Jn-J1[0][0]):.2e}")
