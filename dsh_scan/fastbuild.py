#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fastbuild.py — cached fast replacement for mk_probe_strict.build_matrices.
Caches G(s,deg), powers of c1, c2, (1+eps), and factorial ratios, which are
recomputed O(n^2 * splits^2) times in the original. Results are EXACTLY equal
(identical Fraction arithmetic, just memoized). Verified in verify_fastbuild.py.
Usage: import fastbuild; fastbuild.patch(s)   # s = loaded mk_probe_strict module
"""
import math
from fractions import Fraction as Fr


def make_fast_build_matrices(orig_ldl_none=None):
    def build_matrices_fast(k, eps, r, basis_list, H_cache):
        fac = {n: math.factorial(n) for n in range(0, 3 * 40 + 400)}
        c1, c2 = Fr(1) - eps, 2 * eps
        splits = {a: split_a(list(a)) for a in basis_list}

        # ---- caches ----
        G_cache = {}
        def G(s, deg):
            key = (s, deg)
            v = G_cache.get(key)
            if v is not None:
                return v
            tot = Fr(0)
            for j in range(s + 1):
                tot += Fr(math.comb(s, j)) * c1 ** j * c2 ** (s - j) * fac[j] / fac[k - 1 + j + deg]
            G_cache[key] = tot
            return tot

        maxdeg = max((sum(a) for a in basis_list), default=0)
        c1pow = [Fr(1)]
        c2pow = [Fr(1)]
        eppow = [Fr(1)]
        for _ in range(2 * maxdeg + 2 * r + 100):
            c1pow.append(c1pow[-1] * c1)
            c2pow.append(c2pow[-1] * c2)
            eppow.append(eppow[-1] * (Fr(1) + eps))
        facratio = {}  # (j, deg) -> fac[j]/fac[k-1+j+deg]
        def F(j, deg):
            key = (j, deg)
            v = facratio.get(key)
            if v is None:
                v = fac[j] / fac[k - 1 + j + deg]
                facratio[key] = v
            return v

        n = len(basis_list)
        I = [[Fr(0)] * n for _ in range(n)]
        J1 = [[Fr(0)] * n for _ in range(n)]
        epk = eppow[k] * fac[2 * r]
        for ia, alpha in enumerate(basis_list):
            for ib, beta in enumerate(basis_list):
                gamma = multiset_key(tuple(sorted(alpha + beta)))
                deg = sum(gamma)
                I[ia][ib] = eppow[k + deg + 2 * r] * fac[2 * r] * H_of(list(gamma), k, H_cache) / fac[k + 2 * r + deg]
                tot = Fr(0)
                for ca, Sa, ga in splits[alpha]:
                    Ba = Fr(fac[r]) * Fr(fac[Sa]) / Fr(fac[r + Sa + 1])
                    for cb, Sb, gb in splits[beta]:
                        Bb = Fr(fac[r]) * Fr(fac[Sb]) / Fr(fac[r + Sb + 1])
                        mu = multiset_key(tuple(sorted(ga + gb)))
                        deg2 = sum(mu)
                        s = 2 * r + 2 + Sa + Sb
                        Gv = G(s, deg2)
                        # tot += ca*cb*Ba*Bb * c1^(k-1+deg2) * H * G
                        tot += ca * cb * Ba * Bb * c1pow[k - 1 + deg2] * H_of(list(mu), k - 1, H_cache) * Gv
                J1[ia][ib] = tot
        return I, J1
    return build_matrices_fast


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


def H_of(parts, coords, cache):
    key = (multiset_key(parts), coords)
    if key in cache:
        return cache[key]
    dp = {(): Fr(1)}
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
                ndp[ns] = ndp.get(ns, Fr(0)) + cnt * mult
            ns = tuple(sorted(state + (v,)))
            ndp[ns] = ndp.get(ns, Fr(0)) + cnt
        dp = ndp
    val = sum(
        cnt * math.prod(math.factorial(s_) for s_ in state) * math.factorial(coords) // math.factorial(coords - len(state))
        for state, cnt in dp.items()
        if len(state) <= coords
    )
    val = Fr(val)
    cache[key] = val
    return val


def patch(s):
    """Replace s.build_matrices with the cached version."""
    s.build_matrices = make_fast_build_matrices()
