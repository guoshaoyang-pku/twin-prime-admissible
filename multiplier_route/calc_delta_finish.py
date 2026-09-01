#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""calc_delta_finish.py — 从检查点完成 Kato-Temple 诊断 (跳过 LU)
加载 calc_delta_ckpt_19_e1_25.json (w, rho, num, den) + 矩阵, 计算:
  δ², δ, λ̂₂^{(19)} (deflation 幂迭代), U = ρ + δ²/(ρ−λ̂₂), 判定 U < 4?
用法: python3 calc_delta_finish.py <D> <en> <ed>
"""
import sys, json, math, pickle, time
import gmpy2
from gmpy2 import mpq, mpfr, get_context

D = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
k = 49
get_context().precision = 256
t0 = time.time()

ckpt = json.load(open(f'/data4/guoshaoyang/dsh_scan2/calc_delta_ckpt_{D}_e{en}_{ed}.json'))
w = [mpfr(s) for s in ckpt['w']]
rho = mpfr(ckpt['rho']); num = mpfr(ckpt['num']); den = mpfr(ckpt['den'])
n = len(w)
print(f"checkpoint loaded: n={n}, ρ(M尺度) = {float(k*rho):.8f}", flush=True)

fnD = f'/data4/guoshaoyang/dsh_scan2/frac_cache_49_{D}_e{en}_{ed}_all.pkl'
fnD1 = f'/data4/guoshaoyang/dsh_scan2/frac_cache_49_{D+1}_e{en}_{ed}_all.pkl'
with open(fnD, 'rb') as f: I_D, J_D = pickle.load(f)
with open(fnD1, 'rb') as f: I_D1, J_D1 = pickle.load(f)
print(f"matrices loaded ({time.time()-t0:.0f}s)", flush=True)

# δ² = wᵀI_D1 w − 2ρ·num + ρ²·den  (I_D1 用 mpfr)
I1 = [[mpfr(I_D1[i][j]) for j in range(n)] for i in range(n)]
Iw = [sum(I1[i][j]*w[j] for j in range(n)) for i in range(n)]
wIw = sum(w[i]*Iw[i] for i in range(n))
delta2 = wIw - 2*rho*num + rho*rho*den
delta = gmpy2.sqrt(abs(delta2)) if delta2 >= 0 else mpfr(0)
print(f"δ² = {float(delta2):.4e}  δ = {float(delta):.4e}  ({time.time()-t0:.0f}s)", flush=True)

# λ̂₂: deflation 幂迭代 (I 内积正交)
vd = json.load(open(f'/data4/guoshaoyang/dsh_scan2/rayleigh_vec_49_{D}_e{en}_{ed}.json'))
v = [mpfr(s) for s in vd['v_scaled']]
dd = [mpfr(s) for s in vd['dd']]
nD = len(v)
a = [v[i]*dd[i] for i in range(nD)]
amax = max(abs(x) for x in a)
a = [x/amax for x in a]
a1 = [x/gmpy2.sqrt(mpfr(den)) for x in a]
lam1 = rho
ID = [[mpfr(I_D[i][j]) for j in range(nD)] for i in range(nD)]
JD = [[mpfr(J_D[i][j]) for j in range(nD)] for i in range(nD)]
def Jx(x): return [sum(JD[i][j]*x[j] for j in range(nD)) for i in range(nD)]
def Ix(x): return [sum(ID[i][j]*x[j] for j in range(nD)) for i in range(nD)]
Ia1 = Ix(a1)
x = [mpfr(0.001*(i%7)+0.0001) for i in range(nD)]
Ix0 = Ix(x)
c0 = sum(a1[m]*Ix0[m] for m in range(nD))
x = [x[i] - a1[i]*c0 for i in range(nD)]
lam2_hist = []
for it in range(120):
    Jxv = Jx(x); Ixv = Ix(x)
    c = sum(a1[m]*Ixv[m] for m in range(nD))
    xd = [Jxv[i] - lam1*Ia1[i]*c for i in range(nD)]
    Ixd = Ix(xd)
    nrm = gmpy2.sqrt(sum(xd[i]*Ixd[i] for i in range(nD)))
    if float(nrm) == 0: break
    x = [v/nrm for v in xd]
    if it % 20 == 19:
        Jxf = Jx(x); Ixf = Ix(x)
        lam2_hist.append(sum(x[i]*Jxf[i] for i in range(nD))/sum(x[i]*Ixf[i] for i in range(nD)))
Jxf = Jx(x); Ixf = Ix(x)
lam2 = sum(x[i]*Jxf[i] for i in range(nD))/sum(x[i]*Ixf[i] for i in range(nD))
if lam2_hist:
    print(f"deflation 轨迹 (k·λ): {[float(k*v) for v in lam2_hist]}", flush=True)
print(f"λ̂₂^({D}) ≈ {float(k*lam2):.6f} (k·λ̂₂)  ({time.time()-t0:.0f}s)", flush=True)

gap = rho - lam2
U = rho + (delta2/den)/gap   # Temple 需相对残差 δ²/‖u‖²
print(f"gap(λ尺度) = {float(gap):.4e}", flush=True)
print(f"【诊断】U(M尺度) = {float(k*U):.6f}  (δ 小 ⟹ u_{D} 接近真特征函数)", flush=True)
print(f"VERDICT: k·U < 4 ? {'✓' if float(k*U) < 4 else '✗'}", flush=True)
print(f"用时 {time.time()-t0:.0f}s", flush=True)
