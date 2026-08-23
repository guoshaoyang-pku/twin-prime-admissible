#!/usr/bin/env python3
"""cs_opt.py — 优化 Cauchy-Schwarz 权重 g 使无限维上界最小
g(s) = C * s^{-p} * (s+alpha)^{-q}; 约束 int_{s0}^{k s0} g <= k-1 对所有 s0 in [0,1+eps]
上界 = sup_t sum_i 1/g(s_i), s_i = 1+eps - sum t + k t_i
若上界 < 4 => M_{k,eps} < 4 无限维严格证明!
"""
import numpy as np
from scipy.optimize import minimize, differential_evolution
from scipy.integrate import quad

def g_int(p, q, alpha, a, b):
    """int_a^b s^{-p}(s+alpha)^{-q} ds 数值积分"""
    return quad(lambda s: s**(-p) * (s + alpha)**(-q), a, b, limit=100)[0]

def C_from_constraint(p, q, alpha, k, eps):
    """最大 C 使约束对所有 s0 in [0, 1+eps] 满足"""
    # 约束: C * int_{s0}^{k s0} <= k-1; 找 max over s0 的 int
    worst = 0
    for s0 in np.linspace(1e-10, 1 + eps, 300):
        v = g_int(p, q, alpha, s0, k * s0)
        if v > worst:
            worst = v
    return (k - 1) / worst

def upper_bound(p, q, alpha, C, k, eps, nstart=30, niter=50, rng_seed=7):
    """sup over t of sum_i 1/g(s_i) = sum_i s_i^p (s_i+alpha)^q / C"""
    rng = np.random.default_rng(rng_seed)
    best = -1
    for it in range(nstart):
        u = rng.dirichlet(np.ones(k)) * (1 + eps)
        def obj(t):
            s = 1 + eps - t.sum() + k * t
            return -np.sum(s**p * (s + alpha)**q) / C
        cons = ({'type': 'ineq', 'fun': lambda t: 1 + eps - np.sum(t)})
        res = minimize(obj, u, method='SLSQP', bounds=[(0, 1+eps)]*k,
                       constraints=cons, options={'maxiter': niter, 'ftol': 1e-12})
        if -res.fun > best:
            best = -res.fun
    return best

if __name__ == '__main__':
    k, eps = 49, 1/50
    # 基准: p=1, q=0 -> 论文
    for (p, q, alpha) in [(1.0, 0.0, 0.0), (0.99, 0.0, 0.0), (0.98, 0.0, 0.0),
                          (0.95, 0.0, 0.0), (0.9, 0.0, 0.0),
                          (0.99, 0.1, 0.5), (0.99, 0.2, 0.5), (0.95, 0.1, 0.5),
                          (0.95, 0.2, 0.5), (0.9, 0.1, 0.5), (0.9, 0.2, 0.5)]:
        if alpha == 0 and q > 0: continue
        C = C_from_constraint(p, q, alpha, k, eps)
        ub = upper_bound(p, q, alpha, C, k, eps, nstart=12)
        print(f'p={p} q={q} alpha={alpha}: C={C:.4f} 上界={ub:.4f} {"<4!!" if ub < 4 else ""}')
