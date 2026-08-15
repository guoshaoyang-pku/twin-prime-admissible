#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
M_{k,eps} 数值探针 v2：幂和单项式族 + 精确有理数闭式积分
========================================================
Polymath8b 判据：无条件纪录 H1 <= H(k) 需 M_{k,eps} > 4（θ=1/2, BV）。
论文实测：M_{50,1/25} > 4.0043（k=50 首次过线）；M_54 ≥ 4.00238（ε=0）。

函数族：F(t) = (1+eps−Σt)^r · g(p)，g 为幂和 p_a=Σt_i^a 的多项式
（基 = 幂和单项式 p_α = ∏ p_a^{m_a}，总度数 ≤ D）。
关键恒等式：
  · p_α·p_β = p_{α⊎β}（幂和环中乘积平凡）
  · ∫_{(1+ε)R_k} (1+ε−Σt)^s·p_γ = (1+ε)^{k+deg+s}·s!·H(γ)/(k+s+deg)!
  · ∫_{(1−ε)R_{k−1}} (1+ε−Σt')^s·p_μ = (1−ε)^{k−1+|μ|}·H(μ)·G(s,|μ|)
    其中 H(γ) = Σ_{槽位划分为坐标组} ∏(组和)!（DP 计算），
    G(s,deg) = Σ_j C(s,j)(1−ε)^j(2ε)^{s−j}·j!/(k−1+j+deg)!
  · 内积分 ∫_0^L (L−t_1)^r·t_1^S = B(r+1,S+1)·L^{r+1+S}
这是启发式下界（受限族 + 浮点特征值），与论文数值对照用。

用法: python3 mk_probe.py [k1] [k2] [eps_num] [eps_den] [D] [P]
"""
import sys
import math
from fractions import Fraction as Fr


def multiset_key(parts):
    """multiset → 排序元组（可哈希）"""
    return tuple(sorted(parts))


def gen_multisets(max_deg, max_parts, min_val=1):
    """生成所有 part 多重集：总度数 ≤ max_deg，槽位数 ≤ max_parts，part 值 ≥ min_val"""
    res = {}
    def rec(deg_used, parts):
        key = multiset_key(parts)
        res[key] = sum(parts)
        for v in range(min_val, max_deg - deg_used + 1):
            if len(parts) < max_parts:
                rec(deg_used + v, parts + [v])
    rec(0, [])
    return res  # key → degree


def H_of(parts, coords, cache):
    """H(γ; coords) = Σ_{槽位(带标签)划分为 g 个组} (coords)!/(coords−g)! · ∏_组 (组和)!
    因子 (coords)!/(coords−g)! = P(coords, g)：把组分配到不同坐标的方式数。"""
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    # 槽位带标签：按顺序处理；状态 = 组和多重集（元组）
    dp = {(): Fr(1)}
    for v in parts:
        ndp = {}
        for state, cnt in dp.items():
            # 加入已有组
            for idx, s in enumerate(state):
                if idx > 0 and state[idx - 1] == s:
                    continue  # 相同组和只处理一次
                mult = state.count(s)
                ns = list(state)
                ns[idx] = s + v
                ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, Fr(0)) + cnt * mult
            # 开新组
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, Fr(0)) + cnt
        dp = ndp
    val = sum(
        cnt * math.prod(math.factorial(s) for s in state) * math.factorial(coords) // math.factorial(coords - len(state))
        for state, cnt in dp.items()
        if len(state) <= coords  # 组数不能超过坐标数
    )
    val = Fr(val)
    cache[key] = val
    return val


def split_a(parts):
    """a(α; S, γ)：α 的槽位分配到 t_1（和 S）与 t'（多重集 γ）的带权计数
    返回 [(coeff, S, γ_key)]"""
    from collections import Counter
    cnt = Counter(parts)
    res = []
    vals = sorted(cnt)
    def rec(i, chosen_j, S, rest):
        if i == len(vals):
            res.append((math.prod(math.comb(cnt[v], j) for v, j in chosen_j), S, multiset_key(rest)))
            return
        v = vals[i]
        m = cnt[v]
        for j in range(m + 1):
            rec(i + 1, chosen_j + [(v, j)], S + j * v, rest + [v] * (m - j))
    rec(0, [], 0, [])
    return res


def main():
    k1 = int(sys.argv[1]) if len(sys.argv) > 1 else 44
    k2 = int(sys.argv[2]) if len(sys.argv) > 2 else 54
    eps = Fr(int(sys.argv[3]), int(sys.argv[4])) if len(sys.argv) > 4 else Fr(1, 25)
    D = int(sys.argv[5]) if len(sys.argv) > 5 else 8
    P = int(sys.argv[6]) if len(sys.argv) > 6 else 8
    rlist = [6, 10, 16, 24]

    basis = gen_multisets(D, P)          # 基：度数 ≤ D
    basis_list = sorted(basis, key=lambda k: (basis[k], k))
    print(f"eps={eps}  D={D}  P={P}  基大小={len(basis_list)}  r ∈ {rlist}")

    H_cache = {}
    splits = {a: split_a(list(a)) for a in basis_list}

    c1 = Fr(1) - eps
    c2 = 2 * eps
    fac = {n: math.factorial(n) for n in range(0, 3 * D + 160)}

    def G(s, deg, k):
        tot = Fr(0)
        for j in range(s + 1):
            tot += Fr(math.comb(s, j)) * c1 ** j * c2 ** (s - j) * fac[j] / fac[k - 1 + j + deg]
        return tot

    def I_entry(alpha, beta, r, k):
        gamma = multiset_key(tuple(sorted(alpha + beta)))
        deg = sum(gamma)
        return (Fr(1) + eps) ** (k + deg + 2 * r) * fac[2 * r] * H_of(list(gamma), k, H_cache) / fac[k + 2 * r + deg]

    def J1_entry(alpha, beta, r, k):
        tot = Fr(0)
        sa = splits[alpha]
        sb = splits[beta]
        for ca, Sa, ga in sa:
            Ba = fac[r] * fac[Sa] / fac[r + Sa + 1]
            for cb, Sb, gb in sb:
                Bb = fac[r] * fac[Sb] / fac[r + Sb + 1]
                mu = multiset_key(tuple(sorted(ga + gb)))
                deg = sum(mu)
                s = 2 * r + 2 + Sa + Sb
                tot += ca * cb * Ba * Bb * c1 ** (k - 1 + deg) * H_of(list(mu), k - 1, H_cache) * G(s, deg, k)
        return tot

    def largest_gen_eig(I, J, restarts=6, passes=50):
        """坐标下降最大化 Q(c) = (c^T J c)/(c^T I c)，每坐标闭式最优。无线性代数，稳健。"""
        n = len(I)
        Ifl = [[float(I[i][j]) for j in range(n)] for i in range(n)]
        Jfl = [[float(J[i][j]) for j in range(n)] for i in range(n)]
        best = 0.0
        rnd = [0.6180339887498949]
        for seed in range(restarts):
            x = [1.0] + [0.0] * (n - 1)
            # 伪随机初始化（确定性）
            r = seed * 0.7548776662466927
            for i in range(1, n):
                r = (r * 16807.0) % 2147483647.0
                x[i] = 0.5 + (r / 2147483647.0)
            for _ in range(passes):
                improved = False
                for i in range(n):
                    # Q(t) = (a + 2bt + dt^2)/(A + 2Bt + Dt^2)，对 t 闭式求最优
                    a = sum(x[p] * Jfl[p][q] * x[q] for p in range(n) for q in range(n))
                    A = sum(x[p] * Ifl[p][q] * x[q] for p in range(n) for q in range(n))
                    b = sum(Jfl[i][q] * x[q] for q in range(n) if q != i)
                    d = Jfl[i][i]
                    B = sum(Ifl[i][q] * x[q] for q in range(n) if q != i)
                    D = Ifl[i][i]
                    # 导数零点: (b + d t)(A + 2Bt + Dt^2) = (B + D t)(a + 2bt + dt^2)
                    # 展开: c2 t^2 + c1 t + c0 = 0
                    c2 = d * B - D * b
                    c1 = 2 * (d * A - D * a) + 2 * (b * B - B * b)  # 第二项恒 0
                    c1 = 2 * (d * A - D * a)
                    c0 = b * A - B * a
                    roots = []
                    if abs(c2) > 1e-300:
                        disc = c1 * c1 - 4 * c2 * c0
                        if disc >= 0:
                            sq = math.sqrt(disc)
                            roots.append((-c1 + sq) / (2 * c2))
                            roots.append((-c1 - sq) / (2 * c2))
                    elif abs(c1) > 1e-300:
                        roots.append(-c0 / c1)
                    t_best = None; q_best = None
                    for t in roots + [0.0]:
                        xn = x[:]; xn[i] = t
                        num = sum(xn[p] * Jfl[p][q] * xn[q] for p in range(n) for q in range(n))
                        den = sum(xn[p] * Ifl[p][q] * xn[q] for p in range(n) for q in range(n))
                        if den > 0:
                            qv = num / den
                            if q_best is None or qv > q_best:
                                q_best, t_best = qv, t
                    if t_best is not None:
                        x[i] = t_best
                        improved = True
                if not improved:
                    break
            num = sum(x[p] * Jfl[p][q] * x[q] for p in range(n) for q in range(n))
            den = sum(x[p] * Ifl[p][q] * x[q] for p in range(n) for q in range(n))
            if den > 0 and num / den > best:
                best = num / den
        return best

    import importlib.util, fastbuild
    spec = importlib.util.spec_from_file_location("st", "mk_probe_strict.py")
    st = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(st)
    fastbuild.patch(st)
    for k in range(k1, k2 + 1, 2):
        # 预计算本 k 需要的 H（坐标数 k 与 k−1，按需惰性填充）
        for coords in (k, k - 1):
            for key in gen_multisets(2 * D, 2 * P):
                H_of(list(key), coords, H_cache)
        best, best_r = 0.0, None
        for r in rlist:
            I, J = st.build_matrices(k, eps, r, basis_list, H_cache)
            M = k * largest_gen_eig(I, J)
            if M > best:
                best, best_r = M, r
        flag = "> 4 ✓ 过线" if best > 4 else "< 4 ✗ 未达"
        print(f"k={k:3d}  M_{{{k},{eps}}} ≳ {best:.4f}  (r*={best_r})   {flag}")


if __name__ == "__main__":
    main()
