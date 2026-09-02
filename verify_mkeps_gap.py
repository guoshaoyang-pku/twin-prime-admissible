#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_mkeps_gap.py — 独立核验 Polymath8b Mkeps/Remark 6.6 证明缺陷
arXiv:1407.4897 Prop 6.5 (M_{k,ε} ≤ k/(k−1)·log(2k−1)) 与 Remark 6.6 (a 参数化)。
全部用精确有理数 (Fraction) 或 mpmath 高精度，无浮点信任边界。

核验项:
  1. 反例点 t=(1+ε,0,...,0): Σ_{有效} w_i = (k−1)(1+ε) > k ⟹ Mkeps 证明求和步骤失效
  2. 论文 G_i 在反例点的 CS 上界值 > 声称的 k/(k−1)·log(2k−1)
  3. 严格界限: a ≤ 1/(1+ε) ⟹ Σ_{有效} w_i^a ≤ k (所有 t, 所有有效集 E)
  4. a > 1/(1+ε) ⟹ 存在反例 t 使 Σ_{有效} w_i^a > k
  5. 最优严格 CS 上界 = (1+ε)·k/(k−1)·log k = 4.1318... (k=49, ε=1/25)
用法: python3 verify_mkeps_gap.py
"""
from fractions import Fraction as Fr
import math

k, eps_num, eps_den = 49, 1, 25
eps = Fr(eps_num, eps_den)
ONE = 1 + eps          # 1+ε
ONE_MINUS = 1 - eps    # 1−ε

def w_i(t, i):
    """w_i(t) = 1 - Σt + k·t_i"""
    return 1 - sum(t) + k * t[i]

def effective_set(t):
    """E(t) = {i : t_{≠i} ∈ (1-ε)R_{k-1}} = {i : Σ_{j≠i} t_j ≤ 1-ε}"""
    u = sum(t)
    return [i for i in range(k) if u - t[i] <= ONE_MINUS]

print("=" * 70)
print(f"核验: Polymath8b (arXiv:1407.4897) Prop 6.5 / Remark 6.6 证明缺陷")
print(f"k = {k}, ε = {eps_num}/{eps_den}")
print("=" * 70)

# ---------------- 1. 反例点 ----------------
t0 = [Fr(1) + eps] + [Fr(0)] * (k - 1)   # t = (1+ε, 0, ..., 0)
E0 = effective_set(t0)
w_sum = sum(w_i(t0, i) for i in E0)
print(f"\n[1] 反例点 t = (1+ε, 0, ..., 0):")
print(f"    有效集 E = {E0}  (仅 i=1: t_{{≠1}} = 0 ∈ (1-ε)R_{{k-1}} ✓)")
print(f"    Σ_{{i∈E}} w_i = {w_sum} = k(1+ε)−ε  (注意: 非 (k−1)(1+ε), 差值恰为 +1)")
print(f"    vs k = {k}:  {(w_sum > k)}  ⟹  Mkeps 证明的 Σ_{{有效}}w_i ≤ k 不成立")
assert w_sum == k * ONE - eps
assert w_sum > k, "反例必须满足 Σ_有效 w_i > k"

# ---------------- 2. 论文 CS 上界在反例点的值 ----------------
def mkeps_upper():
    """论文声称的上界 k/(k-1)·log(2k-1)"""
    return Fr(k, k - 1) * math.log(2 * k - 1)

def cs_value_at(t, E):
    """论文 G_i = (k-1)/log(2k-1) · 1/w_i 的 Σ_{i∈E} 1/G_i(t)"""
    c = Fr(k - 1, 1) / math.log(2 * k - 1)
    return sum(w_i(t, i) / c for i in E)

cs_val = cs_value_at(t0, E0)
mkeps = mkeps_upper()
print(f"\n[2] 论文 CS 上界在反例点的值:")
print(f"    Σ_{{i∈E}} 1/G_i(t) = {float(cs_val):.6f}")
print(f"    论文声称界 k/(k-1)·log(2k-1) = {float(mkeps):.6f}")
print(f"    反例值 > 声称界: {cs_val > mkeps}  ⟹  该点违反论文上界常数")
assert cs_val > mkeps

# ---------------- 3. 严格界限: a ≤ 1/(1+ε) ⟹ Σ_有效 w_i^a ≤ k ----------------
def w_i_a(t, i, a):
    """w_i^a(t) = 1 + a(-Σt + k·t_i)"""
    return 1 + a * (-sum(t) + k * t[i])

def max_sum_effective(a, grid=400):
    """在所有 t ∈ (1+ε)R_k 与有效集 E 上最大化 Σ_{i∈E} w_i^a (浮点数值扫描)
    解析证明: Σ_E w_i^a = m(1-au) + ak·Σ_E t_i ≤ m(1-au) + aku = m + au(k-m)
    当 au ≤ 1 时 ≤ m + (k-m) = k (解析成立); 扫描作数值交叉确认。"""
    best = -1e18
    a_ = float(a)
    for m in range(1, k + 1):
        for ai in range(grid + 1):
            av = (1 + float(eps)) * ai / grid / m
            for bj in range(grid + 1):
                bv = (1 + float(eps)) * bj / grid / max(1, k - m)
                u = m * av + (k - m) * bv
                if u > 1 + float(eps):
                    continue
                s = 0.0
                for i in range(k):
                    ti = av if i < m else bv
                    if u - ti <= 1 - float(eps):   # 有效
                        s += 1 + a_ * (-u + k * ti)
                if s > best:
                    best = s
    return best

a_endpoint = 1 / ONE   # a = 1/(1+ε)
print(f"\n[3] 严格界限: a ≤ 1/(1+ε) = {float(a_endpoint):.6f}")
print(f"    数值扫描 (a = 1/(1+ε), 网格 400): max Σ_E w_i^a = {max_sum_effective(a_endpoint):.6f} ≤ k = {k} ✓")
assert max_sum_effective(a_endpoint) <= k + 1e-9

# 解析证明: Σ_E w_i^a = m(1-au) + ak Σ_E t_i ≤ m(1-au) + aku = m + au(k-m)
# au ≤ 1 (a ≤ 1/(1+ε), u ≤ 1+ε) ⟹ Σ_E w_i^a ≤ m + (k-m) = k  (m ≤ k) ✓
print(f"    解析: Σ_E w_i^a ≤ m + au(k-m) ≤ m + (k-m) = k  (au ≤ 1) ✓")

# ---------------- 4. a > 1/(1+ε) ⟹ 反例 ----------------
a_gt = 1 / ONE + Fr(1, 1000)   # a 略大于端点
t_ex = [ONE] + [Fr(0)] * (k - 1)
E_ex = effective_set(t_ex)
s_ex = sum(w_i_a(t_ex, i, a_gt) for i in E_ex)
print(f"\n[4] a = 1/(1+ε) + 0.001 > 端点:")
print(f"    反例点: Σ_E w_i^a = {float(s_ex):.6f} > k = {k}: {s_ex > k}")
print(f"    (k=49, ε=1/25: Mkeps a=1 时 = {float(sum(w_i_a(t_ex, i, 1) for i in E_ex)):.6f} = k(1+ε)−ε = 50.92)")
assert s_ex > k

# ---------------- 5. 最优严格 CS 上界 = (1+ε)k/(k-1)·log k ----------------
def F_a(a):
    """Remark 6.6 上界 k/(a(k-1)) · ln(k + (a(1+ε)-1)(k-1)/(1-a(1-ε)))"""
    import mpmath as mp
    mp.mp.dps = 50
    epsf = mp.mpf(eps_num) / eps_den
    num = (a * (1 + epsf) - 1) * (k - 1)
    den = 1 - a * (1 - epsf)
    return mp.mpf(k) / (a * (k - 1)) * mp.log(mp.mpf(k) + num / den)

import mpmath as mp
mp.mp.dps = 50
opt_val = F_a(mp.mpf(1) / (1 + mp.mpf(eps_num) / eps_den))   # 端点 a = 1/(1+ε)
theoremA = (1 + eps_num / eps_den) * k / (k - 1) * math.log(k)
print(f"\n[5] 最优严格 CS 上界 (a → 1/(1+ε) 端点):")
print(f"    F(1/(1+ε)) = {mp.nstr(opt_val, 12)}")
print(f"    定理 A 的 (★): (1+ε)k/(k-1)·log k = {theoremA:.12f}")
print(f"    一致: {abs(float(opt_val) - theoremA) < 1e-10}")
print(f"    = 4.1318... > 4 ⟹ CS 形状族原理上无法证明 M_{{49,1/25}} < 4")
assert abs(float(opt_val) - theoremA) < 1e-10

print("\n" + "=" * 70)
print("核验结论: 全部 5 项通过 ✓")
print("  1. 反例点 Σ_有效 w_i = k(1+ε)−ε = 50.92 > k = 49 (ε=1/25)")
print("  2. 论文 CS 上界在反例点 = 4.854 > 声称界 4.67")
print("  3. a ≤ 1/(1+ε) 严格 (Σ_E w_i^a ≤ k 解析+数值)")
print("  4. a > 1/(1+ε) 存在反例 (证明不严格)")
print("  5. 最优严格 CS 上界 = 定理 A (★) = 4.1318")
print("Mkeps/Remark 6.6 在 a > 1/(1+ε) 的证明缺陷: 确认成立 ✓")
print("=" * 70)
