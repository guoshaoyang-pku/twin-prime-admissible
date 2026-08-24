#!/usr/bin/env python3
"""bfi_fast.py — 加速解析积分: int F dt_i via 一次 DP 输出所有 subsets
intF(t,i) = sum_{r,gamma} v * sum_{S⊆gamma} c(r,|S|,sum_S) * u0^{r+|S|+1} * p_{gamma\S}(t 除 i)
其中 p_T(t 除 i) 从一次 DP (仅 t 除 i 坐标) 得到: state[T] 全部子集.
"""
import numpy as np, math, sys
sys.path.insert(0, '.')

k, D, eps = 49, 27, 1/25
v = np.load('ev_k49_d27_eps1_25_Inorm.npy')  # I 内积归一化

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
gamma_coeffs = {}
for gamma in parts_all:
    gamma_coeffs[gamma] = [0.0] * (D - sum(gamma) + 1)
idx = 0
for gamma in parts_all:
    for r in range(0, D - sum(gamma) + 1):
        gamma_coeffs[gamma][r] = v[idx]; idx += 1

# 预计算: 每 gamma 的 subsets 信息 (sum, len) + beta 系数
from functools import lru_cache
@lru_cache(maxsize=None)
def gamma_info(gamma):
    m = len(gamma)
    subs = []
    for mask in range(1 << m):
        s_sum = 0; s_len = 0
        for j in range(m):
            if mask >> j & 1:
                s_sum += gamma[j]; s_len += 1
        subs.append((mask, s_sum, s_len))
    return subs

def p_subsets(t_excl, gamma):
    """对 t_excl (k-1 坐标) 的 DP: state[T] = p_T(t_excl) 对全部 T ⊆ parts"""
    m = len(gamma)
    if m == 0: return np.array([1.0])
    size = 1 << m
    state = np.zeros(size); state[0] = 1.0
    for ti in t_excl:
        if ti <= 0: continue
        pw = np.array([ti ** g for g in gamma])
        new = state.copy()
        for j in range(m):
            idx0 = np.where((np.arange(size) & (1 << j)) == 0)[0]
            new[idx0 | (1 << j)] += state[idx0] * pw[j]
        state = new
    return state

def intF_fast(t, i):
    """int_0^{u0} F(t1=t_i, ...) dt_i — 解析 (Beta 公式)"""
    u0 = 1 + eps - (t.sum() - t[i])
    if u0 <= 1e-15: return 0.0
    t_excl = np.concatenate([t[:i], t[i+1:]])
    tot = 0.0
    for gamma, coeffs in gamma_coeffs.items():
        m = len(gamma)
        if m == 0:
            # gamma = (): p = 1, int (u0-t)^r dt = u0^{r+1}/(r+1)
            val = 0.0
            u_pow = u0
            for c in reversed(coeffs):
                val = val * u0 + c
            # int F_gamma0 dt_i = sum_r c_r * u0^{r+1}/(r+1)
            s = 0.0
            for r, c in enumerate(coeffs):
                if c != 0:
                    s += c * u0**(r+1) / (r+1)
            tot += s
            continue
        state = p_subsets(t_excl, gamma)
        # 正确公式 (distinct index: t_i 至多分配给一个 part):
        # int (u0-t)^r p_gamma(t) dt_i = u0^{r+1}/(r+1) * p_gamma(t_excl)
        #     + sum_j beta(r, gamma_j) * u0^{r+gamma_j+1} * p_{gamma\{j}}(t_excl)
        comp_all = (1 << m) - 1
        s = 0.0
        upow = 1.0
        for r, c in enumerate(coeffs):
            if c == 0:
                upow *= u0; continue
            # S = ∅
            bsum = state[comp_all] * u0**(r+1) / (r+1)
            # S = {j} 单点
            for j in range(m):
                gj = gamma[j]
                comp_j = comp_all ^ (1 << j)
                bsum += (math.factorial(r)*math.factorial(gj)/math.factorial(r+gj+1)) * u0**(r+gj+1) * state[comp_j]
            s += c * bsum
            upow *= u0
        tot += s
    return tot

if __name__ == '__main__':
    import numpy as np
    from scipy.integrate import quad
    # 对照: 与 bfi_int (慢但独立) 或 Gauss
    rng = np.random.default_rng(0)
    for it in range(2):
        t = rng.dirichlet(np.ones(k)) * (1+eps) * rng.uniform(0.3, 1)
        v1 = intF_fast(t, 0)
        print(f'点{it}: intF_fast = {v1:.8e}')
