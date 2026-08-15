#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
floatbuild.py — float64 versions of the H DP and Gram-matrix build.
Only for HEURISTIC estimates (numpy eigenvalues); exact values come from the
rational pipeline (mk_probe_strict / fastbuild). The formulas are identical to
the exact ones, with math.factorial computed via lgamma-free direct ints cast
to float, so relative errors ~1e-15.
"""
import math
from fractions import Fraction as Fr


def multiset_key(parts):
    return tuple(sorted(parts))


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


def H_of_float(parts, coords, cache):
    """H(parts; coords) in float64. Same DP as the exact version."""
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    dp = {(): 1.0}
    for v in parts:
        ndp = {}
        for state, cnt in dp.items():
            for idx, s_ in enumerate(state):
                if idx > 0 and state[idx - 1] == s_:
                    continue
                mult = state.count(s_)
                ns = list(state)
                ns[idx] = s_ + v
                ns = tuple(sorted(ns))
                ndp[ns] = ndp.get(ns, 0.0) + cnt * mult
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, 0.0) + cnt
        dp = ndp
    val = 0.0
    for state, cnt in dp.items():
        if len(state) <= coords:
            val += cnt * math.prod(math.factorial(s_) for s_ in state) * (
                math.factorial(coords) / math.factorial(coords - len(state)))
    cache[key] = val
    return val


def build_matrices_float(k, eps, r, basis_list, H_cache):
    """Float Gram pair (I, J1). eps is a float. Returns (Ifl, Jfl) as lists of lists."""
    fac = {n: math.factorial(n) for n in range(0, 3 * 60 + 600)}
    c1, c2 = 1.0 - eps, 2.0 * eps
    splits = {a: split_a(list(a)) for a in basis_list}
    G_cache = {}
    def G(s, deg):
        key = (s, deg)
        v = G_cache.get(key)
        if v is not None:
            return v
        tot = 0.0
        for j in range(s + 1):
            tot += math.comb(s, j) * c1 ** j * c2 ** (s - j) * fac[j] / fac[k - 1 + j + deg]
        G_cache[key] = tot
        return tot
    maxdeg = max((sum(a) for a in basis_list), default=0)
    c1pow, c2pow, eppow = [1.0], [1.0], [1.0]
    one_eps = 1.0 + eps
    for _ in range(2 * maxdeg + 2 * r + 200):
        c1pow.append(c1pow[-1] * c1)
        c2pow.append(c2pow[-1] * c2)
        eppow.append(eppow[-1] * one_eps)
    n = len(basis_list)
    I = [[0.0] * n for _ in range(n)]
    J1 = [[0.0] * n for _ in range(n)]
    for ia, alpha in enumerate(basis_list):
        for ib, beta in enumerate(basis_list):
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            I[ia][ib] = eppow[k + deg + 2 * r] * fac[2 * r] * H_of_float(list(gamma), k, H_cache) / fac[k + 2 * r + deg]
            tot = 0.0
            for ca, Sa, ga in splits[alpha]:
                Ba = fac[r] * fac[Sa] / fac[r + Sa + 1]
                for cb, Sb, gb in splits[beta]:
                    Bb = fac[r] * fac[Sb] / fac[r + Sb + 1]
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    deg2 = sum(mu)
                    s = 2 * r + 2 + Sa + Sb
                    tot += ca * cb * Ba * Bb * c1pow[k - 1 + deg2] * H_of_float(list(mu), k - 1, H_cache) * G(s, deg2)
            J1[ia][ib] = tot
    return I, J1


def float_lambda_max(I, J1):
    """Diagonal-preconditioned float estimate of lambda_max(J1, I)."""
    import numpy as np
    n = len(I)
    Ifl = np.array(I, dtype=float)
    Jfl = np.array(J1, dtype=float)
    d = 1.0 / np.sqrt(np.maximum(np.diag(Ifl), 1e-300))
    Isc = Ifl * d[:, None] * d[None, :]
    Jsc = Jfl * d[:, None] * d[None, :]
    try:
        L = np.linalg.cholesky(Isc)
    except np.linalg.LinAlgError:
        Isc = Isc + 1e-13 * np.eye(n)
        L = np.linalg.cholesky(Isc)
    Linv = np.linalg.solve(L, np.eye(n))
    B = Linv @ Jsc @ Linv.T
    ev = np.linalg.eigvalsh(B)
    return float(ev[-1])
