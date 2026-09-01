#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sanity_kk2_exact.py — kk=2 确定性手算验证 (无 MC, 精确有理 + 解析)
目的: 确定 J1 矩阵的"单切片 i=1"约定与体积因子, 提供可手算基准。
手算 (k=2, ε=1/25, e_0 = 1 常数基):
  J_1(e_0,e_0) = ∫_{t_2∈(1-ε)R_1} (∫_0^{1+ε-t_2} 1 dx)² dt_2
               = ∫_0^{1-ε} (1+ε-t_2)² dt_2 = [(1+ε)³-(2ε)³]/3 = 0.374784
  B(e_0,e_0)  = vol((1+ε)R_2) = (1+ε)²/2 = 0.5408
  Rayleigh(e_0) = J_1/B = 0.69299...;  M 的贡献 = k·J_1/I = 2·0.374784/0.5408
公式 (frac_multi, 无 ×k):
  J[0][0] = (1-ε)·[4ε² + 2ε(1-ε) + (1-ε)²/3]   (见 docstring 推导)
"""
import sys
sys.path.insert(0, '.')
from fractions import Fraction as Fr
from math import factorial, comb
from sanity_check import build_matrices

kk, D = 2, 2
basis, B, J = build_matrices(kk, D)
n = len(basis)
eps = Fr(1, 25)

print(f'kk={kk} D={D}: 基 = {basis}')
print('=' * 60)

# ---- 解析手算值 (e_0 = (r=0, gamma=()), 即常数 1) ----
E = 1 + eps                      # 1+ε = 26/25
# J_1 单切片: ∫_0^{1-ε} (1+ε-t)² dt = [(1+ε)³-(2ε)³]/3
J1_ana = (E**3 - (2*eps)**3) / 3
# B: vol((1+ε)R_2) = (1+ε)²/2
B_ana = E**2 / 2
print(f'[解析] J_1(e_0,e_0) = [(1+ε)³-(2ε)³]/3 = {float(J1_ana):.10f} = {J1_ana}')
print(f'[解析] B(e_0,e_0)   = (1+ε)²/2 = {float(B_ana):.10f} = {B_ana}')
print(f'[解析] Rayleigh(e_0) = J_1/B = {float(J1_ana/B_ana):.10f}')
print(f'[解析] M 的常数函数贡献 k·J_1/I = {float(2*J1_ana/B_ana):.10f}')

# ---- 公式值 ----
print('-' * 60)
# 找到 e_0 索引 (r=0, gamma=())
i0 = basis.index((0, ()))
print(f'e_0 索引 = {i0}')
Jf = float(J[i0][i0]); Bf = float(B[i0][i0])
print(f'[公式] J[{i0}][{i0}] = {Jf:.10f}   vs 解析 {float(J1_ana):.10f}   rel={abs(Jf-float(J1_ana))/float(J1_ana):.1e}')
print(f'[公式] B[{i0}][{i0}] = {Bf:.10f}   vs 解析 {float(B_ana):.10f}   rel={abs(Bf-float(B_ana))/float(B_ana):.1e}')
print(f'[公式] J/B = {Jf/Bf:.10f}   vs 解析 {float(J1_ana/B_ana):.10f}')
assert abs(Jf - float(J1_ana)) / float(J1_ana) < 1e-14, 'J 公式与解析不一致'
assert abs(Bf - float(B_ana)) / float(B_ana) < 1e-14, 'B 公式与解析不一致'
print('=> J1 公式 = 单切片 i=1 矩阵 (不乘 k)。M = k·λ_max(J1,B) 约定确认。')

# ---- e_1 = (1+ε-Σt) (r=1, gamma=()) 的解析: J_1(e_1,e_1) = ∫(∫_0^L (L-x)dx)² dt_2
# ∫_0^L (L-x)dx = L²/2;  J_1 = ∫_0^{1-ε} (L(t_2)²/2)² dt_2 = ∫_0^{1-ε} (1+ε-t_2)⁴/4 dt_2
# = [(1+ε)⁵-(2ε)⁵]/(5·4) = [(1+ε)⁵-(2ε)⁵]/20
i1 = basis.index((1, ()))
L_ana = (E**5 - (2*eps)**5) / 20
J1f = float(J[i1][i1])
print('-' * 60)
print(f'[解析] J_1(e_1,e_1) = [(1+ε)⁵-(2ε)⁵]/20 = {float(L_ana):.10f}')
print(f'[公式] J[{i1}][{i1}] = {J1f:.10f}   rel={abs(J1f-float(L_ana))/float(L_ana):.1e}')
assert abs(J1f - float(L_ana)) / float(L_ana) < 1e-14
print('=> e_1 切片积分约定确认 ✓')

# ---- 交叉项 J(e_0,e_1) ----
# J_1(e_0,e_1) = ∫_0^{1-ε} (∫_0^L 1 dx)(∫_0^L (L-x)dx) dt_2 = ∫_0^{1-ε} L·(L²/2) dt_2
# = (1/2)∫_0^{1-ε}(1+ε-t_2)³dt_2 = (1/2)[(1+ε)⁴-(2ε)⁴]/4 = [(1+ε)⁴-(2ε)⁴]/8
J01_ana = (E**4 - (2*eps)**4) / 8
J01f = float(J[i0][i1])
print(f'[解析] J_1(e_0,e_1) = [(1+ε)⁴-(2ε)⁴]/8 = {float(J01_ana):.10f}')
print(f'[公式] J[{i0}][{i1}] = {J01f:.10f}   rel={abs(J01f-float(J01_ana))/float(J01_ana):.1e}')
assert abs(J01f - float(J01_ana)) / float(J01_ana) < 1e-14
print('=> 交叉项确认 ✓')

# ---- Rayleigh 方向 (D=2, k=2): C = (4/k)B - J ----
import numpy as np
from scipy.linalg import eigh
Bf_m = np.array([[float(x) for x in row] for row in B])
Jf_m = np.array([[float(x) for x in row] for row in J])
lam = eigh(Jf_m, Bf_m, eigvals_only=True)
lam_max = lam[-1]
print('-' * 60)
print(f'k=2 D=2: λ_max(J,B) = {lam_max:.10f}, 4/k = 2.0')
print(f'  λ_max < 4/k: {lam_max < 2.0}   M = k·λ = {2*lam_max:.6f} < 4: {2*lam_max < 4}')
print('G3 kk=2 确定性验证: 全部一致 ✓ (J1 单切片约定, 体积因子, Rayleigh 方向)')
