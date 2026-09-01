#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""multiplier_engine.py — 乘子证书计算引擎 (M_{49,1/25} ≤ sup_t m_w(t) < 4)
主线: 给定显式正对称多项式 w (论文基系数), 计算
  m_w(t) = Σ_{i: t_{≠i}∈(1-eps)R_{k-1}} Wᵢ(t_{≠i}) / w(t),  Wᵢ = ∫_0^{L(t_{≠i})} w dt_i
区域定义与 frac_multi.py 逐行对齐:
  - 基 {(1+eps-P1)^r p_γ : r+deg(γ)≤D, γ 偶划分} (论文等价)
  - 切片积分 ∫_0^L (L-x)^r x^{Sa} dx = L^{r+Sa+1}·r!Sa!/(r+Sa+1)!  (Ba, 同 frac_multi)
  - split_a 展开 p_α = Π_{d∈α}(x^d + S_d)  (同 frac_multi)
  - L = 1+eps-u_{≠i}; 有效切片: u_{≠i} ≤ 1-eps (t_{≠i} ∈ (1-eps)R_{k-1})
用法:
  python3 multiplier_engine.py --probe D <w_json> <lambda_star>   # 浮点探针
  python3 multiplier_engine.py --wjson D <w_json>                  # 输出 Wᵢ 幂和基展开
"""
import sys, json, math
from math import factorial, comb
from fractions import Fraction as Fr

k, eps = 49, Fr(1, 25)

def gen_even_partitions(max_deg):
    res = []
    def rec(deg_used, parts):
        res.append(tuple(parts))
        start = parts[-1] if parts else 2
        for v in range(start, max_deg - deg_used + 1, 2):
            rec(deg_used + v, parts + [v])
    rec(0, [])
    return res

def build_basis(D):
    parts = gen_even_partitions(D)
    basis = []
    for gamma in parts:
        dg = sum(gamma)
        for r in range(0, D - dg + 1):
            basis.append((r, gamma))
    return basis

def split_a(parts):
    """同 frac_multi.split_a: 返回 [(ca, Sa, rest)]"""
    from collections import Counter
    cnt = Counter(parts)
    res = []
    vals = sorted(cnt)
    def rec(i, chosen, S, rest):
        if i == len(vals):
            res.append((math.prod(math.comb(cnt[v], j) for v, j in chosen), S, tuple(sorted(rest))))
            return
        v = vals[i]
        for j in range(cnt[v] + 1):
            rec(i + 1, chosen + [(v, j)], S + j * v, rest + [v] * (cnt[v] - j))
    rec(0, [], 0, [])
    return res

# ---------------- Wᵢ 的幂和基展开 ----------------
def p1_power_mult(power, mu):
    """P1^power · p_mu = p_{mu + (1,...,1)}"""
    return tuple(sorted(list(mu) + [1] * power))

def w_edge_expand(wcoeff, i):
    """Wᵢ(t_{≠i}) = ∫_0^{L} w dt_i 在幂和基 {p_λ} 下的展开
    wcoeff: {(r, gamma): Fraction}; 返回 {lambda: Fraction}
    Wᵢ = Σ_{(r,γ),c} c·Σ_{T⊆γ} ca·Ba·L^{r+ΣT+1}·Π_{d∉T} p_d(t_{≠i})
    L^{A} = (1+eps-u)^A = Σ_a C(A,a)(1+eps)^{A-a}(-u)^a
    """
    res = {}
    for (r, gamma), c in wcoeff.items():
        for ca, Sa, rest in split_a(gamma):
            A = r + Sa + 1
            Ba = Fr(factorial(r) * factorial(Sa), factorial(r + Sa + 1))
            for a in range(A + 1):
                lam = p1_power_mult(a, rest)
                coef = c * ca * Ba * comb(A, a) * (1 + eps)**(A - a) * (-1)**a
                res[lam] = res.get(lam, Fr(0)) + coef
    return res

# ---------------- 取值 (浮点) ----------------
def p_lambda_val(lam, t):
    """p_λ(t) = Π_{d∈λ} (Σ_j t_j^d)"""
    v = 1.0
    for d in lam:
        v *= sum(x ** d for x in t)
    return v

def eval_poly_base(coeff, t):
    """Σ coef[λ]·p_λ(t), coeff: {tuple: Fraction}"""
    return sum(float(c) * p_lambda_val(lam, t) for lam, c in coeff.items())

def w_eval_paperbasis(wcoeff, t):
    """w(t) = Σ c·(1+eps-Σt)^r·p_γ(t)"""
    u = sum(t)
    w = 1 + eps - u
    tot = Fr(0)
    for (r, gamma), c in wcoeff.items():
        p = 1
        for d in gamma:
            p *= sum(x ** d for x in t)
        tot += c * (w ** r) * p
    return float(tot)

def mw_at(wcoeff, edge_cache, t):
    """m_w(t) = Σ_{有效 i} Wᵢ(t_{≠i})/w(t)"""
    u = sum(t)
    wv = w_eval_paperbasis(wcoeff, t)
    if wv <= 0:
        return None
    num = 0.0
    for i in range(k):
        t_ne = t[:i] + t[i+1:]
        u_ne = u - t[i]
        if u_ne <= 1 - eps:   # 有效切片
            num += eval_poly_base(edge_cache[i], t_ne)
    return num / wv



# ---------------- 对称点快速评估 (m 个 a, k-m 个 b) ----------------
def p_lambda_sym(lam, m, a, b):
    """p_λ 在对称点的值: Π_{d∈λ}(m·a^d + (k-m)·b^d)"""
    v = 1.0
    kk = k
    for d in lam:
        v *= (m * a ** d + (kk - m) * b ** d)
    return v

def eval_poly_sym(coeff, m, a, b):
    return sum(float(c) * p_lambda_sym(lam, m, a, b) for lam, c in coeff.items())

def mw_sym(wcoeff, edge_cache, m, a, b):
    """对称 t (m 个 a, k-m 个 b) 的 m_w"""
    u = m * a + (k - m) * b
    if u > 1 + eps + 1e-12:
        return None
    # w(t)
    wv = 0.0
    for (r, gamma), c in wcoeff.items():
        p = 1.0
        for d in gamma:
            p *= (m * a ** d + (k - m) * b ** d)
        wv += float(c) * (1 + eps - u) ** r * p
    if wv <= 0:
        return None
    num = 0.0
    # a 组切片的 W: t_{≠i} = (m-1) 个 a, (k-m) 个 b
    if m > 0:
        u_ne = u - a
        if u_ne <= 1 - eps + 1e-12:
            num += m * eval_poly_sym(edge_cache[0], m - 1, a, b)
    # b 组切片的 W
    if k - m > 0:
        u_ne = u - b
        if u_ne <= 1 - eps + 1e-12:
            num += (k - m) * eval_poly_sym(edge_cache[1], m, a, b)
    return num / wv

def probe_sym(wcoeff, edge_cache, lam_star, n_grid=60, n_rand=20000, seed=7):
    """对称网格 + 随机探针"""
    import numpy as np
    rng = np.random.default_rng(seed)
    worst = -1e9; arg = None
    # 网格
    for m in range(1, k + 1):
        for a in np.linspace(1e-6, (1 + eps) / m, n_grid):
            for b in np.linspace(0, (1 + eps) / max(1, k - m), n_grid):
                mw = mw_sym(wcoeff, edge_cache, m, float(a), float(b))
                if mw is not None and mw > worst:
                    worst, arg = mw, (m, a, b)
    # 随机
    negN = 0; totN = 0
    for _ in range(n_rand):
        m = int(rng.integers(1, k + 1))
        a = rng.uniform(0, (1 + eps) / m)
        b = rng.uniform(0, (1 + eps) / max(1, k - m))
        mw = mw_sym(wcoeff, edge_cache, m, a, b)
        if mw is None: continue
        totN += 1
        if mw - lam_star * k < 0: negN += 1
        if mw > worst: worst, arg = mw, (m, a, b)
    return worst, arg, negN, totN

# ---------------- 主流程 ----------------
if __name__ == '__main__':
    import numpy as np
    if len(sys.argv) < 4:
        print(__doc__); sys.exit(1)
    mode = sys.argv[1]; D = int(sys.argv[2]); wf = sys.argv[3]
    with open(wf) as f:
        wd = json.load(f)   # {"r,gamma": "num/den"} 或 {"r,gamma": num}
    wcoeff = {}
    for key, val in wd.items():
        r, gamma = key.split(';')
        gamma = tuple(map(int, gamma.split(','))) if gamma else ()
        wcoeff[(int(r), gamma)] = Fr(val) if isinstance(val, str) else Fr(int(val), 1)
    # 对齐检查: 基合法性
    basis = build_basis(D)
    bset = set(basis)
    for key in wcoeff:
        if key not in bset:
            print(f'警告: 基元素 {key} 不在 D={D} 基中', file=sys.stderr)
    # 预计算 Wᵢ (对称 ⟹ 只需 i=0, 其余相同结构但坐标不同——用通用展开)
    edge_cache = [w_edge_expand(wcoeff, i) for i in range(k)]
    if mode == '--wjson':
        out = {'D': D, 'k': k, 'eps': '1/25',
               'W_edges': [[str(c) for c in ec.items()] for ec in edge_cache]}
        print(json.dumps(out, ensure_ascii=False))
    elif mode == '--probe':
        lam_star = float(sys.argv[4])
        rng = np.random.default_rng(42)
        worst = (-1e9, None)
        negN = 0; totN = 0
        # 网格: 对称 (m, a) 结构 + 随机
        for trial in range(20000):
            m = rng.integers(1, k+1)
            a = rng.uniform(0, (1+eps)/m)
            b = rng.uniform(0, (1+eps)/max(1, k-m))
            t = [float(a)] * m + [float(b)] * (k - m)
            if sum(t) > 1 + eps + 1e-12:
                continue
            mw = mw_at(wcoeff, edge_cache, t)
            if mw is None:
                continue
            totN += 1
            N = mw - lam_star * k   # N = ΣWᵢ − λ*·w·k? 按 m_w 定义 N = ΣWᵢ − λ*·w
            if N < 0:
                negN += 1
            if mw > worst[0]:
                worst = (mw, t)
        print(f'探针: {totN} 点, m_w max ≈ {worst[0]:.6f} at t≈{worst[1][:3]}...')
        print(f'  λ*·k = {lam_star*k:.6f};  N<0 比例 {negN}/{totN}')
        print(f'  {"<4!!!" if worst[0] < 4 else ">4"}')
