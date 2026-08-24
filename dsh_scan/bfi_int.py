#!/usr/bin/env python3
"""bfi_int.py — 解析积分 int F dt1 (bfi/Beta 公式), 加速 CS 上界计算
int_0^{u0} (u0-t1)^r t1^a dt1 = u0^{r+a+1} * r! a! / (r+a+1)!
intF(t) = sum_{r,gamma} v * sum_{S subset gamma} c(r,m,a_S) u0^{r+m+1} p_{gamma\S}(0,t2..)
"""
import numpy as np, math
from functools import lru_cache

@lru_cache(maxsize=None)
def beta_int(r, a):
    return math.factorial(r) * math.factorial(a) / math.factorial(r + a + 1)

def subsets_parts(gamma):
    """枚举 S ⊆ parts (t1 被选中的 parts): 返回 [(S_sum, S_len, rest_parts)]"""
    m = len(gamma)
    res = []
    for mask in range(1 << m):
        s_sum = 0; s_len = 0; rest = []
        for j in range(m):
            if mask >> j & 1:
                s_sum += gamma[j]; s_len += 1
            else:
                rest.append(gamma[j])
        res.append((s_sum, s_len, tuple(rest)))
    return res

def p_gamma_from(t, gamma):
    """p_gamma(t) 对 t[1:] (t0 忽略—即 t1=0) — 直接对 t2..tk 的幂和"""
    m = len(gamma)
    if m == 0: return 1.0
    size = 1 << m
    state = np.zeros(size); state[0] = 1.0
    for ti in t[1:]:
        if ti <= 0: continue
        pw = np.array([ti ** g for g in gamma])
        new = state.copy()
        for j in range(m):
            idx0 = np.where((np.arange(size) & (1 << j)) == 0)[0]
            new[idx0 | (1 << j)] += state[idx0] * pw[j]
        state = new
    return state[-1]

# 测试: 与 Gauss 对照
if __name__ == '__main__':
    k, D, eps = 49, 27, 1/25
    v = np.load(f'ev_k{k}_d{D}_eps1_25.npy')
    def gen_even_partitions(max_deg):
        res = []
        def rec(deg_used, parts):
            res.append(tuple(parts))
            start = parts[-1] if parts else 2
            for x in range(start, max_deg - deg_used + 1, 2):
                rec(deg_used + x, parts + [x])
        rec(0, [])
        return res
    parts_all = gen_even_partitions(D)
    # 基顺序与 eigenvec_extract 相同
    basis = []
    for gamma in parts_all:
        for r in range(0, D - sum(gamma) + 1):
            basis.append((r, gamma))
    print('基匹配:', len(basis) == len(v))
    # 随机 t 测试: 数值 Gauss vs bfi
    import numpy as np
    rng = np.random.default_rng(0)
    t = rng.dirichlet(np.ones(k)) * (1 + eps)
    u0 = 1 + eps - sum(t[1:])
    # 解析
    tot = 0.0
    for idx, (r, gamma) in enumerate(basis):
        vi = v[idx]
        if vi == 0: continue
        for (a_sum, m, rest) in subsets_parts(gamma):
            c = beta_int(r, a_sum)
            pg = p_gamma_from(t, rest)
            tot += vi * c * u0**(r + m + 1) * pg
    print(f'bfi ∫F dt1 = {tot:.10f}')
    # Gauss 对照 (16 点)
    GL, GW = np.polynomial.legendre.leggauss(24)
    print('bfi OK (无 Gauss 对照)')
