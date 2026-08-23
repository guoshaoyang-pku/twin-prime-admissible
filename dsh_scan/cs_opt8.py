#!/usr/bin/env python3
"""cs_opt8.py — 分段线性 φ(s) 优化 CS 无限维上界
φ 在 M 个对数节点上的值 (自由参数); 内层 sup 枚举 (m,a) a 取节点值;
约束 int_{s0}^{ks0} 1/phi <= k-1 检查; 外层 Nelder-Mead 多起点 + 局部 polish
"""
import numpy as np
from scipy.optimize import minimize
from scipy.interpolate import interp1d

def build_phi(vals, sgrid):
    return interp1d(sgrid, vals, kind='linear', bounds_error=False,
                    fill_value=(vals[0], vals[-1]))

def sup_simplex(phi, k, K, nodes, na=200):
    """枚举 (m, a): a 取节点值, b = (K-ma)/(k-m); 分段线性 => 节点候选足够"""
    best = -1e9
    for a in nodes:
        for m in range(1, k):
            b = (K - m * a) / (k - m)
            if b < 0: continue
            val = m * phi(a) + (k - m) * phi(b)
            if val > best: best = val
    # 补充: 均匀 + 顶点
    best = max(best, k * phi(K / k))
    best = max(best, phi(K) + (k - 1) * phi(1e-9))
    return best

def constraint_ok(phi, k, S, n=40):
    for s0 in np.linspace(1e-8, S, n):
        sg = np.linspace(s0, k * s0, 25)
        v = np.trapz(1.0 / np.maximum(phi(sg), 1e-15), sg)
        if v > (k - 1) * 1.001:
            return False
    return True

def objective(vals, sgrid, k, K, S, nodes):
    phi = build_phi(vals, sgrid)
    if not constraint_ok(phi, k, S):
        return 1e6
    return sup_simplex(phi, k, K, nodes)

def run(k, eps, M=8, nstart=30):
    S = 1 + eps; K = k * S
    sgrid = np.geomspace(1e-6, K, M)
    nodes = sgrid
    lin = np.log(k) / (k - 1)
    best = (1e9, None)
    rng = np.random.default_rng(0)
    for st in range(nstart):
        if st == 0:
            x0 = lin * sgrid
        else:
            x0 = lin * sgrid * np.exp(rng.normal(0, 0.5, M))
        res = minimize(objective, x0, args=(sgrid, k, K, S, nodes),
                       method='Nelder-Mead',
                       options={'maxiter': 400, 'xatol': 1e-11, 'fatol': 1e-13})
        if res.fun < best[0]:
            best = (res.fun, res.x)
        if st % 5 == 0:
            print(f'  start {st}: best {best[0]:.6f}', flush=True)
    print(f'k={k} eps={eps}: 论文 {K*np.log(k)/(k-1):.6f} → 优化 {best[0]:.6f}  {"<4!!!" if best[0] < 4 else ""}')
    return best[0]

if __name__ == '__main__':
    import sys
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    run(k, en / ed)
