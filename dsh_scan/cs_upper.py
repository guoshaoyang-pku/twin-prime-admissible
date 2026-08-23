#!/usr/bin/env python3
"""cs_upper.py — Cauchy-Schwarz 无限维上界: M_{k,eps} <= sup_t sum_i 1/G_i(t)
G_i(t) = g(s_i), s_i = 1+eps - sum_j t_j + k*t_i
约束: int_{s0}^{k*s0} g(s) ds <= k-1 对所有 s0 in [0, 1+eps]
上界: sup over t in (1+eps)R_k of sum_i 1/g(s_i(t))
论文选择 g(s)=C/s: 上界 = (1+eps)*k/(k-1)*ln k (验证!)
用法: python3 cs_upper.py k eps_num eps_den [gtype] 
"""
import numpy as np
from scipy.optimize import differential_evolution, minimize

def s_i(t, k, eps, i):
    return 1 + eps - t.sum() + k * t[i]

def cs_bound(k, eps, g, g_inv):
    """g_inv(s) = 1/g(s); 返回上界 (sup over t) 与最大约束违反"""
    def obj(t):
        return -sum(g_inv(s_i(t, k, eps, i)) for i in range(k))
    # 约束: sum t <= 1+eps, t_i >= 0; 采样优化
    # 用差分进化 (k 大时用少量点 + 局部优化)
    n = k
    bounds = [(0, 1 + eps)] * n
    cons = ({'type': 'ineq', 'fun': lambda t: 1 + eps - np.sum(t)})
    res = differential_evolution(lambda t: obj(t), bounds, constraints=(cons,),
                                 seed=42, maxiter=200, tol=1e-10, polish=True,
                                 workers=1, popsize=15, mutation=(0.5, 1.5))
    best = -res.fun
    # 约束检查: 对所有 s0 in [0,1+eps] 采样检查 int_{s0}^{ks0} g <= k-1
    viol = 0.0
    for s0 in np.linspace(1e-9, 1 + eps, 200):
        val = g(s0, k * s0)
        viol = max(viol, val - (k - 1))
    return best, viol, res.x

# 论文 g: g_int(a,b) = int_a^b C/s ds = C ln(b/a)
def paper_g(k, C):
    def g(a, b):
        return C * np.log(b / a)
    return g

def paper_g_inv(s):
    return s  # 1/(C/s) 归一化 C 后: 上界 = sum s_i / C; C = (k-1)/ln k
    # 实际: G_i = (k-1)/ln k * 1/s_i -> 1/G_i = ln k/(k-1) * s_i

if __name__ == '__main__':
    import sys
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    eps = en / ed
    # 论文: G_i = C/s_i, C = (k-1)/ln k
    lnk = np.log(k)
    C = (k - 1) / lnk
    g_int = paper_g(k, C)
    g_inv = lambda s: lnk / (k - 1) * s
    bound, viol, x = cs_bound(k, eps, g_int, g_inv)
    print(f'k={k} eps={en}/{ed}')
    print(f'论文解析值: {(1+eps)*k/(k-1)*lnk:.6f}')
    print(f'数值 sup:   {bound:.6f}')
    print(f'约束违反:   {viol:.2e} (应 <= 0)')
    print(f'最优 t 采样: {x[:5]}...')
