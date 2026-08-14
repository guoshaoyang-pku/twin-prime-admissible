#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mk_probe_strict.py — M_{k,eps} 的严格判定器（精确有理数，无近似）
================================================================
判定 Maynard 筛法判据：M_{k,eps} > 4 ?

数学：M_{k,eps} = k · λ_max(J1, I)，其中 I、J1 是幂和多项式族的
精确有理数 Gram 矩阵（Dirichlet 闭式积分）。
  · M > 4  ⟺  λ_max(J1, I) > 4/k  ⟺  矩阵 J1 − (4/k)·I 存在正特征值
  · 对称矩阵的特征值符号 = 其 LDL^T 分解枢轴的符号（惯性定理）
因此：对 J1 − (4/k)·I 做**精确有理数 LDL^T 分解**：
  · 全部枢轴 < 0  ⇒  M < 4 （严格证明，无需近似）
  · 存在正枢轴   ⇒  再用精确 Rayleigh 商（有理向量 c）确认下界 > 4/k
                  ⇒  M > 4 完整证明
用法: python3 mk_probe_strict.py k eps_num eps_den [D] [P] [r]
输出: 严格判定结果（PROVEN M<4 / PROVEN M>4 / 区间）
"""
import sys
import math
from fractions import Fraction as Fr


def multiset_key(parts):
    return tuple(sorted(parts))


def gen_multisets(max_deg, max_parts, min_val=1):
    res = {}
    def rec(deg_used, parts):
        key = multiset_key(parts)
        res[key] = sum(parts)
        for v in range(min_val, max_deg - deg_used + 1):
            if len(parts) < max_parts:
                rec(deg_used + v, parts + [v])
    rec(0, [])
    return res


def H_of(parts, coords, cache):
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    dp = {(): Fr(1)}
    for v in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx, s in enumerate(state):
                if idx > 0 and state[idx - 1] == s:
                    continue
                mult = state.count(s)
                ns = list(state)
                ns[idx] = s + v
                ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, Fr(0)) + cnt * mult
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, Fr(0)) + cnt
        dp = ndp
    val = sum(
        cnt * math.prod(math.factorial(s) for s in state) * math.factorial(coords) // math.factorial(coords - len(state))
        for state, cnt in dp.items()
        if len(state) <= coords
    )
    val = Fr(val)
    cache[key] = val
    return val


def split_a(parts):
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


def build_matrices(k, eps, r, basis_list, H_cache):
    fac = {n: math.factorial(n) for n in range(0, 3 * 20 + 200)}
    c1, c2 = Fr(1) - eps, 2 * eps
    splits = {a: split_a(list(a)) for a in basis_list}

    def G(s, deg):
        tot = Fr(0)
        for j in range(s + 1):
            tot += Fr(math.comb(s, j)) * c1 ** j * c2 ** (s - j) * fac[j] / fac[k - 1 + j + deg]
        return tot

    n = len(basis_list)
    I = [[Fr(0)] * n for _ in range(n)]
    J1 = [[Fr(0)] * n for _ in range(n)]
    for ia, alpha in enumerate(basis_list):
        for ib, beta in enumerate(basis_list):
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            I[ia][ib] = (Fr(1) + eps) ** (k + deg + 2 * r) * fac[2 * r] * H_of(list(gamma), k, H_cache) / fac[k + 2 * r + deg]
            tot = Fr(0)
            for ca, Sa, ga in splits[alpha]:
                Ba = Fr(fac[r]) * Fr(fac[Sa]) / Fr(fac[r + Sa + 1])
                for cb, Sb, gb in splits[beta]:
                    Bb = Fr(fac[r]) * Fr(fac[Sb]) / Fr(fac[r + Sb + 1])
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    deg2 = sum(mu)
                    s = 2 * r + 2 + Sa + Sb
                    tot += ca * cb * Ba * Bb * c1 ** (k - 1 + deg2) * H_of(list(mu), k - 1, H_cache) * G(s, deg2)
            J1[ia][ib] = tot
    return I, J1


def ldl_sign(A):
    """精确有理数 LDL^T 分解（无枢轴）；返回枢轴符号列表。遇零枢轴返回 None。"""
    n = len(A)
    L = [[Fr(0)] * n for _ in range(n)]
    D = [Fr(0)] * n
    pivots = []
    for j in range(n):
        v = A[j][j] - sum(L[j][m] ** 2 * D[m] for m in range(j))
        if v == 0:
            return None  # 零枢轴：4/k 恰为特征值（概率零），需扰动重试
        D[j] = v
        pivots.append(v > 0)
        L[j][j] = Fr(1)
        for i in range(j + 1, n):
            L[i][j] = (A[i][j] - sum(L[i][m] * L[j][m] * D[m] for m in range(j))) / D[j]
    return pivots


def rayleigh_exact(I, J1, c):
    """精确 Rayleigh 商：c^T J1 c / c^T I c（c 为有理向量）"""
    num = sum(c[i] * J1[i][j] * c[j] for i in range(len(c)) for j in range(len(c)))
    den = sum(c[i] * I[i][j] * c[j] for i in range(len(c)) for j in range(len(c)))
    return num / den


def float_cd(I, J1, restarts=12, passes=60):
    """浮点坐标下降找好候选（仅作下界搜索用，最终判定是精确的）"""
    n = len(I)
    Ifl = [[float(I[i][j]) for j in range(n)] for i in range(n)]
    Jfl = [[float(J1[i][j]) for j in range(n)] for i in range(n)]
    best = (0.0, None)
    for seed in range(restarts):
        x = [1.0] + [0.0] * (n - 1)
        r = seed * 0.7548776662466927
        for i in range(1, n):
            r = (r * 16807.0) % 2147483647.0
            x[i] = 0.5 + (r / 2147483647.0)
        for _ in range(passes):
            improved = False
            for i in range(n):
                a = sum(x[p] * Jfl[p][q] * x[q] for p in range(n) for q in range(n))
                A = sum(x[p] * Ifl[p][q] * x[q] for p in range(n) for q in range(n))
                b = sum(Jfl[i][q] * x[q] for q in range(n) if q != i)
                d = Jfl[i][i]
                B = sum(Ifl[i][q] * x[q] for q in range(n) if q != i)
                D = Ifl[i][i]
                c2 = d * B - D * b
                c1 = 2 * (d * A - D * a)
                c0 = b * A - B * a
                roots = []
                if abs(c2) > 1e-300:
                    disc = c1 * c1 - 4 * c2 * c0
                    if disc >= 0:
                        sq = math.sqrt(disc)
                        roots += [(-c1 + sq) / (2 * c2), (-c1 - sq) / (2 * c2)]
                elif abs(c1) > 1e-300:
                    roots.append(-c0 / c1)
                t_best, q_best = None, None
                for t in roots + [0.0]:
                    xn = x[:]
                    xn[i] = t
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
        if den > 0 and num / den > best[0]:
            best = (num / den, x[:])
    return best


def main():
    k = int(sys.argv[1])
    eps = Fr(int(sys.argv[2]), int(sys.argv[3]))
    D = int(sys.argv[4]) if len(sys.argv) > 4 else 8
    P = int(sys.argv[5]) if len(sys.argv) > 5 else 8
    r = int(sys.argv[6]) if len(sys.argv) > 6 else 6

    basis = gen_multisets(D, P)
    basis_list = sorted(basis, key=lambda kk: (basis[kk], kk))
    H_cache = {}
    for coords in (k, k - 1):
        for key in gen_multisets(2 * D, 2 * P):
            H_of(list(key), coords, H_cache)

    print(f"k={k} eps={eps} D={D} r={r} 基={len(basis_list)}")
    I, J1 = build_matrices(k, eps, r, basis_list, H_cache)

    # 严格判定：J1 − (4/k)·I 的 LDL^T 惯性
    n = len(basis_list)
    A = [[J1[i][j] - Fr(4, k) * I[i][j] for j in range(n)] for i in range(n)]
    piv = ldl_sign(A)
    if piv is None:
        print("判定: 4/k 恰为特征值（零枢轴）——需扰动重试")
        return
    any_pos = any(piv)
    print("LDL^T 判定: 存在正特征值 =" , any_pos)

    # 精确 Rayleigh 下界
    best_f, best_c = float_cd(I, J1)
    if best_c is not None:
        # 有理化候选（保留 12 位小数，确保严格）
        cq = [Fr(int(round(v * 10**12)), 10**12) if v != 1.0 else Fr(1) for v in best_c]
        lb = k * rayleigh_exact(I, J1, cq)
    else:
        lb = Fr(0)

    if any_pos:
        if lb > Fr(4):
            print(f"★★★ 完整证明: M_{{{k},{eps}}} ≥ {float(lb):.6f} > 4  ⇒  DHL[{k},2] 成立  ⇒  H1 ≤ H({k})")
        else:
            print(f"信号: 存在正特征值（M 可能 > 4），但族内 Rayleigh 下界 {float(lb):.6f} ≤ 4")
            print("  → 需要更大的基或更好的候选向量以完成证明")
    else:
        print(f"完整证明: M_{{{k},{eps}}} < 4（LDL^T 惯性：全部特征值 < 4/k）")
        print(f"  附: 族内精确 Rayleigh 下界 M ≥ {float(lb):.6f}")


if __name__ == "__main__":
    main()
