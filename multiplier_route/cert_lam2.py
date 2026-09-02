#!/usr/bin/env python3
# λ̂₂^{(19)} 512-bit 收敛认证
import sys, json, math
sys.path.insert(0, '/data4/guoshaoyang/dsh_scan2')
from frac_multi_all import gen_all_partitions
import gmpy2
from gmpy2 import mpfr, get_context
get_context().precision = 512
k, D = 49, 19
import pickle
with open(f'frac_cache_49_{D}_e1_25_all.pkl','rb') as f: I_D, J_D = pickle.load(f)
vd = json.load(open(f'rayleigh_vec_49_{D}_e1_25.json'))
v = [mpfr(s) for s in vd['v_scaled']]; dd = [mpfr(s) for s in vd['dd']]
nD = len(v)
a = [v[i]*dd[i] for i in range(nD)]
amax = max(abs(x) for x in a)
a = [x/amax for x in a]
ck = json.load(open(f'calc_delta_ckpt_{D}_e1_25.json'))
den = mpfr(ck['den']); rho = mpfr(ck['rho'])
a1 = [x/gmpy2.sqrt(den) for x in a]
lam1 = rho
ID = [[mpfr(I_D[i][j]) for j in range(nD)] for i in range(nD)]
JD = [[mpfr(J_D[i][j]) for j in range(nD)] for i in range(nD)]
def Jx(x): return [sum(JD[i][j]*x[j] for j in range(nD)) for i in range(nD)]
def Ix(x): return [sum(ID[i][j]*x[j] for j in range(nD)) for i in range(nD)]
Ia1 = Ix(a1)
x = [mpfr(0.001*(i%7)+0.0001) for i in range(nD)]
Ix0 = Ix(x)
c0 = sum(a1[m]*Ix0[m] for m in range(nD))
x = [x[i]-a1[i]*c0 for i in range(nD)]
lam2_prev = None
for it in range(200):
    Jxv = Jx(x); Ixv = Ix(x)
    c = sum(a1[m]*Ixv[m] for m in range(nD))
    xd = [Jxv[i]-lam1*Ia1[i]*c for i in range(nD)]
    Ixd = Ix(xd)
    nrm = gmpy2.sqrt(sum(xd[i]*Ixd[i] for i in range(nD)))
    x = [vv/nrm for vv in xd]
    if it % 40 == 39:
        Jxf = Jx(x); Ixf = Ix(x)
        lam2 = sum(x[i]*Jxf[i] for i in range(nD))/sum(x[i]*Ixf[i] for i in range(nD))
        diff = abs(float(lam2-lam2_prev)) if lam2_prev else float('inf')
        print(f"iter {it+1}: k·λ̂₂ = {float(k*lam2):.15f}  变化 = {diff:.3e}", flush=True)
        lam2_prev = lam2
Jxf = Jx(x); Ixf = Ix(x)
lam2 = sum(x[i]*Jxf[i] for i in range(nD))/sum(x[i]*Ixf[i] for i in range(nD))
res = [Jxf[i]-lam2*Ixf[i] for i in range(nD)]
res2 = gmpy2.sqrt(sum(res[i]*res[i] for i in range(nD)))
print(f"最终: k·λ̂₂ = {float(k*lam2):.15f}", flush=True)
print(f"残差范数 = {float(res2):.3e}", flush=True)
gap = float(rho - lam2)
print(f"谱隙 ρ−λ̂₂: λ尺度 {gap:.10f}, M尺度 {49*gap:.8f}", flush=True)
