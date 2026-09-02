#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""m1_ptri.py — ⟨u, P₁²u⟩ 的精确计算 (三角形积分)
⟨u,P₁²u⟩ = ∫_{t_{≠1}∈(1−ε)R_{48}}∫∫_{x+y≤L₁} u(x,t_{≠1})u(y,t_{≠1}) dxdy dt_{≠1}
条目: M1[a,b] = Σ_{sa,sb} c_a c_b·Btri(r_a,s_a,r_b,s_b)·RestInt(q, γ'_a∪γ'_b)
  Btri(r1,s1,r2,s2) = ∫∫_{u+v≤1}(1−u)^r1 u^s1 (1−v)^r2 v^s2 du dv  (精确有理闭式)
  RestInt(q,μ) = ∫_{(1−ε)R_{48}} L^q p_μ(rest) drest, L = 1+ε−Σrest
  q = r_a+s_a+r_b+s_b+2
输出: ⟨u,P₁²u⟩ (mpfr), δ_true², U 判定
用法: python3 m1_ptri.py [D] [en] [ed]
"""
import sys, json, math, pickle, time
import multiprocessing as mp
import gmpy2
from gmpy2 import mpq, mpfr, get_context

D = int(sys.argv[1]) if len(sys.argv) > 1 else 19
en = int(sys.argv[2]) if len(sys.argv) > 2 else 1
ed = int(sys.argv[3]) if len(sys.argv) > 3 else 25
k = 49
eps = mpq(en, ed)
E = mpq(1) + eps
get_context().precision = 512
t0 = time.time()

sys.path.insert(0, '/data4/guoshaoyang/dsh_scan2')
from frac_multi_all import gen_all_partitions, split_a

parts = gen_all_partitions(D)
basis = []
for gamma in parts:
    dg = sum(gamma)
    for r in range(0, D - dg + 1):
        basis.append((r, gamma))
n = len(basis)
splits = {gamma: split_a(list(gamma)) for gamma in parts}
fac = [math.factorial(m) for m in range(3*D + 2*k + 100)]
print(f"k={k} D={D} eps={en}/{ed} n={n}", flush=True)

# H 缓存 (coords=48)
H_cache = {}
def H_exact(plist, coords):
    key = (tuple(sorted(plist)), coords)
    v = H_cache.get(key)
    if v is not None:
        return v
    dp = {(): mpq(1)}
    for val in plist:
        ndp = {}
        for state, cnt in dp.items():
            for idx in range(len(state)):
                if idx > 0 and state[idx-1] == state[idx]:
                    continue
                mult = state.count(state[idx])
                ns = list(state); ns[idx] += val; ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, mpq(0)) + cnt*mult
            ns = tuple(sorted(state + (val,)))
            ndp[ns] = ndp.get(ns, mpq(0)) + cnt
        dp = ndp
    tot = mpq(0)
    for state, cnt in dp.items():
        if len(state) <= coords:
            f = math.factorial(coords) // math.factorial(coords - len(state))
            tot += cnt * math.prod(math.factorial(s) for s in state) * f
    H_cache[key] = tot
    return tot

# BtriW: ∫∫_{x,y∈[0,L]}(L−max(x,y))(L−x)^r1 x^s1 (L−y)^r2 y^s2 dxdy / L^{r1+r2+s1+s2+3}
# = I(r1,s1;r2,s2) + I(r2,s2;r1,s1), I = ∫∫_{x≤y}(1−y)^{r2+1}y^{s2}(1−x)^{r1}x^{s1} (归一化 L=1)
# I = Σ_m C(r1,m)(−1)^m·B(r2+2, s2+s1+m+2)/(s1+m+1)
def BtriW(r1, s1, r2, s2):
    def I(rr1, ss1, rr2, ss2):
        tot = mpq(0)
        for m in range(rr1+1):
            a = rr2 + 2
            b = ss2 + ss1 + m + 2
            beta = mpq(fac[a-1]*fac[b-1], fac[a+b-1])
            tot += mpq(math.comb(rr1, m)) * ((-1)**m) * beta / (ss1 + m + 1)
        return tot
    return I(r1, s1, r2, s2) + I(r2, s2, r1, s1)

# RestInt(q, mu): ∫_{(1−ε)R_{48}} L^q p_mu drest
# = (1−ε)^{48+dmu} Σ_j C(q,j)(1−ε)^j(2ε)^{q−j}·j!·H(mu,48)/(48+j+dmu)!
_RI_CACHE = {}
_C1POW = {}
_C2POW = {}
def RestInt(q, mu, coords=48):
    key = (q, tuple(sorted(mu)), coords)
    v = _RI_CACHE.get(key)
    if v is not None:
        return v
    dmu = sum(mu)
    H = H_exact(list(mu), coords)
    c1 = mpq(1) - eps
    c2 = 2*eps
    if coords not in _C1POW:
        _C1POW[coords] = [c1**i for i in range(3*D + 2*k + 100)]
        _C2POW[coords] = [c2**i for i in range(3*D + 2*k + 100)]
    c1p, c2p = _C1POW[coords], _C2POW[coords]
    tot = mpq(0)
    for j in range(q+1):
        tot += mpq(math.comb(q, j)) * c1p[j] * c2p[q-j] * mpq(fac[j]) * H / fac[coords + j + dmu]
    tot *= c1p[coords + dmu]
    _RI_CACHE[key] = tot
    return tot

# 预计算 splits 的 Btri 系数表 (每个 split 的 (c, Sa, grest))
def build_splits_tab():
    tab = {}
    for gamma in parts:
        tab[gamma] = splits[gamma]
    return tab
splits_tab = build_splits_tab()

_GLOB = {}
def _init_worker(tab, facs, epss):
    _GLOB['tab'] = tab; _GLOB['fac'] = facs; _GLOB['eps'] = epss
    _GLOB['c1'] = mpq(1) - epss; _GLOB['c2'] = 2*epss

def _build_row(ia):
    g = _GLOB
    tab = g['tab']; facs = g['fac']
    r1, alpha = basis[ia]
    sa = tab[alpha]
    row = [mpq(0)]*n
    for ib, (r2, beta) in enumerate(basis):
        sb = tab[beta]
        tot = mpq(0)
        for (ca, s1, ga) in sa:
            for (cb, s2, gb) in sb:
                bt = BtriW(r1, s1, r2, s2)
                if bt == 0:
                    continue
                mu = tuple(sorted(ga + gb))
                q = r1 + r2 + s1 + s2 + 3
                ri = RestInt(q, mu)
                tot += ca*cb*bt*ri
        row[ib] = tot
    return ia, row

def main():
    t0 = time.time()
    # 预填充 H 缓存 (单进程, 先算常用 μ)
    print("preparing H cache...", flush=True)
    for gamma in parts:
        for delta in parts:
            H_exact(list(sorted(gamma + delta)), 48)
    print(f"H cache: {len(H_cache)} entries ({time.time()-t0:.0f}s)", flush=True)
    # 并行构建 (行)
    S = 24
    pool = mp.Pool(S, initializer=_init_worker, initargs=(splits_tab, fac, eps))
    rows = {}
    for ia, row in pool.imap_unordered(_build_row, range(n), chunksize=4):
        rows[ia] = row
    pool.close(); pool.join()
    print(f"rows built ({time.time()-t0:.0f}s)", flush=True)
    # 载入特征向量
    vd = json.load(open(f'/data4/guoshaoyang/dsh_scan2/rayleigh_vec_49_{D}_e{en}_{ed}.json'))
    v = [mpfr(s) for s in vd['v_scaled']]
    dd = [mpfr(s) for s in vd['dd']]
    a = [v[i]*dd[i] for i in range(n)]
    amax = max(abs(x) for x in a)
    a = [x/amax for x in a]
    ck = json.load(open(f'/data4/guoshaoyang/dsh_scan2/calc_delta_ckpt_{D}_e{en}_{ed}.json'))
    rho = mpfr(ck['rho']); num = mpfr(ck['num']); den = mpfr(ck['den'])
    # 收缩: ⟨u,P₁²u⟩ = Σ_a a_a Σ_b M1[a,b] a_b
    t1 = time.time()
    uP1sq = mpfr(0)
    for ia in range(n):
        s = sum(mpfr(rows[ia][ib])*a[ib] for ib in range(n))
        uP1sq += a[ia]*s
    print(f"⟨u,P₁²u⟩ = {float(uP1sq):.6e}  ({time.time()-t1:.0f}s)", flush=True)
    # δ_true² = ⟨u,P₁²u⟩ − 2ρ·num + ρ²·den
    delta2_true = uP1sq - 2*rho*num + rho*rho*den
    delta_rel2 = delta2_true/den
    delta_rel = gmpy2.sqrt(abs(delta_rel2)) if delta_rel2 >= 0 else mpfr(0)
    print(f"δ_true² = {float(delta2_true):.6e}", flush=True)
    print(f"δ_true²/den (相对) = {float(delta_rel2):.6e}, δ_true/‖u‖ = {float(delta_rel):.6f}", flush=True)
    # 对照: 投影残差 (calc_delta 已算)
    print(f"对照: δ_proj² = 1.5953e-114, δ_proj²/den = 2.53e-6", flush=True)
    print(f"补空间贡献: {(float(delta2_true) - 1.5953e-114):.3e} (应 ≥ 0)", flush=True)
    # λ̂₂ (512-bit 认证值)
    lam2 = mpfr('0.5111695251756257')/k
    gap = rho - lam2
    U = rho + delta_rel2/gap
    print(f"gap(λ) = {float(gap):.8f}", flush=True)
    print(f"U(M尺度) = {float(k*U):.6f}", flush=True)
    print(f"VERDICT: M_{k},{en}/{ed} ≤ {float(k*U):.6f} < 4 ? {'✓✓ 全空间严格上界!' if float(k*U) < 4 else '✗'}", flush=True)
    json.dump({'uP1sq': str(uP1sq), 'delta2_true': str(delta2_true), 'delta_rel': float(delta_rel),
               'U_M': float(k*U)}, open(f'm1_ptri_{D}_e{en}_{ed}.json', 'w'))
    print(f"saved m1_ptri_{D}_e{en}_{ed}.json ({time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
