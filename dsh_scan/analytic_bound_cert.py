#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""analytic_bound_cert.py — 纯有理数严格证书
定理 (Polymath8b arXiv:1407.4897, Lemma 6.4 / Prop 6.5 / Remark 6.6):
  M_k      <= (k/(k-1)) ln k                       (Lemma 6.4, eps=0)
  M_{k,eps}<= k/(a(k-1)) ln( k + (a(1+eps)-1)(k-1)/(1-a(1-eps)) )
              对 1/(1+eps) < a < 1/(1-eps)          (Remark 6.6)
  令 a -> 1/(1+eps)+ :  M_{k,eps} < (1+eps)(k/(k-1)) ln k  (连续端点)
本脚本: 用 Fraction 纯有理数验证 (1+eps)(k/(k-1)) ln k < 4,
 其中 ln k 的上界用初等幂级数: ln k = 2 artanh((k-1)/(k+1)),
 artanh(z)=Σ z^(2n+1)/(2n+1), 余项 <= z^(2N+3)/((2N+3)(1-z^2)).
输出: 每 (k, eps) 的严格布尔判定. 无任何浮点/区间信任边界.
"""
from fractions import Fraction as Fr

def ln_upper(k, N=200):
    """有理数严格上界 of ln k."""
    z = Fr(k - 1, k + 1)
    zz = z * z
    s = Fr(0)
    zp = z
    for n in range(N + 1):
        s += zp / Fr(2 * n + 1)
        zp *= zz
    R = zp / (Fr(2 * N + 3) * (1 - zz))   # 余项上界 (正项级数)
    return 2 * (s + R)

def m_upper(k, eps_num, eps_den):
    """(1+eps)(k/(k-1)) ln k 的有理上界."""
    return Fr(eps_den + eps_num, eps_den) * Fr(k, k - 1) * ln_upper(k)

def main():
    print("=== 纯有理数严格验证: M_{k,eps} < 4 (Remark 6.6 端点 a->1/(1+eps)) ===")
    print("M_{k,eps} < (1+eps)(k/(k-1)) ln k  (对 0<=eps<1, k>=2, 严格)")
    print()
    header = "k     eps=0        eps=1/200     eps=1/100     eps=1/50      eps=1/25"
    print(header)
    for k in range(2, 51):
        cells = []
        for (en, ed) in [(0, 1), (1, 200), (1, 100), (1, 50), (1, 25)]:
            u = m_upper(k, en, ed)
            ok = u < 4
            cells.append(f"{'STRICT<4' if ok else 'upper>4':>12}")
        print(f"{k:>3}  " + "  ".join(cells))
    print()
    print("结论:")
    print("  对一切 2<=k<=46 与 eps<=1/50: M_{k,eps} < 4 严格成立 (纯有理证书)")
    print("  对一切 2<=k<=42 与 eps<=1/25: M_{k,eps} < 4 严格成立")
    print("  对一切 2<=k<=50 与 eps=0:     M_{k,eps} < 4 严格成立 (Lemma 6.4)")
    print("  k=47..50 @ eps=1/50: 解析上界 >4, 不排除 M>4 (开放)")
    # 各 k 的 eps 阈值 (有理下界): 求最大 1/m 使上界<4
    print()
    print("eps 阈值表 (有理验证: 1/m 使 (1+1/m)(k/(k-1))ln k < 4 的最大 m):")
    for k in range(40, 51):
        m = 1
        while m_upper(k, 1, m) >= 4:   # upper(1/m) 随 m 增大而减小
            m += 1
        print(f"  k={k}: eps <= 1/{m} 严格排除")

if __name__ == "__main__":
    main()
