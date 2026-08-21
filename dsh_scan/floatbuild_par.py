"""并行矩阵构建: 多进程按行分块 (Linux fork 共享只读 H_cache)"""
import math
from fractions import Fraction as Fr
from floatbuild import multiset_key, split_a, H_of_float

def _row_worker(args):
    k, eps, r, basis_list, H_cache, rows = args
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
    one_eps = 1.0 + eps
    eppow = [1.0]
    for _ in range(2 * maxdeg + 2 * r + 200):
        eppow.append(eppow[-1] * one_eps)
    n = len(basis_list)
    I_row = {}
    J_row = {}
    for ia in rows:
        alpha = basis_list[ia]
        I_row[ia] = [0.0] * n
        J_row[ia] = [0.0] * n
        for ib in range(n):
            beta = basis_list[ib]
            gamma = multiset_key(tuple(sorted(alpha + beta)))
            deg = sum(gamma)
            I_row[ia][ib] = eppow[k + deg + 2 * r] * fac[2 * r] * H_of_float(list(gamma), k, H_cache) / fac[k + 2 * r + deg]
            tot = 0.0
            for ca, Sa, ga in splits[alpha]:
                Ba = fac[r] * fac[Sa] / fac[r + Sa + 1]
                for cb, Sb, gb in splits[beta]:
                    Bb = fac[r] * fac[Sb] / fac[r + Sb + 1]
                    mu = multiset_key(tuple(sorted(ga + gb)))
                    deg2 = sum(mu)
                    s = 2 * r + 2 + Sa + Sb
                    tot += ca * cb * Ba * Bb * c1 ** (k - 1 + deg2) * H_of_float(list(mu), k - 1, H_cache) * G(s, deg2)
            J_row[ia][ib] = tot
    return I_row, J_row

def build_matrices_float_par(k, eps, r, basis_list, H_cache, nproc=24):
    import multiprocessing as mp
    n = len(basis_list)
    # 按行分块 (均衡负载: 交错分配)
    chunks = [[] for _ in range(nproc)]
    for ia in range(n):
        chunks[ia % nproc].append(ia)
    args = [(k, eps, r, basis_list, H_cache, rows) for rows in chunks if rows]
    I = [[0.0] * n for _ in range(n)]
    J1 = [[0.0] * n for _ in range(n)]
    with mp.Pool(nproc) as pool:
        for I_row, J_row in pool.map(_row_worker, args):
            for ia, row in I_row.items():
                I[ia] = row
            for ia, row in J_row.items():
                J1[ia] = row
    return I, J1
