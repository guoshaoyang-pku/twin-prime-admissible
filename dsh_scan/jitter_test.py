#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""jitter_test.py — (I, J1) 抖动稳定性测试 (并行)

测试内容:
  [a2]  约化矩阵 J̃ 的 float64 逐项抖动 → eigvalsh 重算 λ_max (检验 float64 特征值稳定性)
  [a2b] 双侧抖动 (J̃+δJ, Ĩ+δI) scipy 广义特征值
  [b]   输入级抖动 J1 (I 保持精确 → SPD 不变): 全管线 256 位重算 λ_max
  [c]   输入级逐项抖动 (I, J1 都抖): 固定已证向量 v* 的 Rayleigh 商灵敏度
        (原始基 I 的 λ_min/λ_max ~ 8e-54, δ≥1e-12 即破坏 SPD, 广义特征值良定义性
         丧失; 故用 RQ(v*) 测量 Maynard 泛函在候选处的输入灵敏度 — 包络定理:
         dλ_max = RQ(v*) 的一阶变化)

用法: python3 jitter_test.py k D [bits=256] [ntrials=3]
"""
import sys, time, pickle, random
import multiprocessing as mp
import numpy as np
import gmpy2
from gmpy2 import mpfr
from fractions import Fraction as Fr

sys.path.insert(0, '.')
import importlib.util
spec = importlib.util.spec_from_file_location("lf", "legendre_fix.py")
lf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lf)

def fullJ_trial(args):
    k, D, delta, seed, bits, cache = args
    random.seed(seed)
    with open(cache, 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    ctx = gmpy2.get_context(); ctx.precision = bits
    Jj = [[mpfr(x.numerator) * (1 + delta * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in J1]
    res = lf.reduce_pair(I, Jj, bits)
    if res[0] == 'fail':
        return (delta, seed, 'SPD_FAIL', None)
    V, s, L, d = res
    lam = float(np.linalg.eigvalsh(np.array([[float(x) for x in row] for row in V]))[-1])
    return (delta, seed, 'ok', lam)

def rq_trial(args):
    k, D, delta, seed, bits, z, cache = args
    random.seed(seed)
    with open(cache, 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    ctx = gmpy2.get_context(); old = ctx.precision; ctx.precision = bits
    z = [mpfr(x) for x in z]
    Ij = [[mpfr(x.numerator) * (1 + delta * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in I]
    Jj = [[mpfr(x.numerator) * (1 + delta * random.uniform(-1, 1)) / mpfr(x.denominator) for x in row] for row in J1]
    num = mpfr(0); den = mpfr(0)
    for i in range(n):
        zi = z[i]
        sn = mpfr(0); sd = mpfr(0)
        Jji = Jj[i]; Iji = Ij[i]
        for j in range(n):
            sn += Jji[j] * z[j]
            sd += Iji[j] * z[j]
        num += zi * sn
        den += zi * sd
    rq = float(num / den)
    ctx.precision = old
    return (delta, seed, 'ok', rq)

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    bits = int(sys.argv[3]) if len(sys.argv) > 3 else 256
    ntrials = int(sys.argv[4]) if len(sys.argv) > 4 else 3
    cache = sys.argv[5] if len(sys.argv) > 5 else f'frac_cache_{k}_{D}.pkl'
    deltas = (1e-12, 1e-10, 1e-8)
    nproc = min(mp.cpu_count(), 24)
    seed0 = 1000
    print(f"k={k} D={D} bits={bits} ntrials={ntrials} deltas={deltas} nproc={nproc}", flush=True)

    # 基线
    with open(cache, 'rb') as f:
        I0, J10 = pickle.load(f)
    n = len(I0)
    res0 = lf.reduce_pair(I0, J10, bits)
    assert res0[0] != 'fail'
    V0, s0, L0, d0 = res0
    J0f = np.array([[float(x) for x in row] for row in V0])
    lam0 = float(np.linalg.eigvalsh(J0f)[-1])
    wvec = np.linalg.eigh(J0f)[1][:, -1]
    ctx = gmpy2.get_context(); old = ctx.precision; ctx.precision = bits
    wm = [mpfr(float(x)) for x in wvec]
    b = [s0[i] * wm[i] for i in range(n)]
    z = [mpfr(0)] * n
    for i in range(n - 1, -1, -1):
        zi = b[i]
        for m in range(i + 1, n):
            zi -= L0[m][i] * z[m]
        z[i] = zi
    ctx.precision = old
    del V0, s0, L0, d0, J0f, wvec, wm, b
    print(f"[baseline] λ_max = {lam0:.15f}  M = {k*lam0:.10f}", flush=True)
    rq0 = lf.verify(z, J10, I0, lam0, bits, label="(baseline)")
    print(f"[baseline] RQ(v*) = {rq0:.15f}  diff = {rq0-lam0:+.3e}", flush=True)

    # [a2] 约化矩阵 float64 抖动
    with open(cache, 'rb') as f:
        I0, J10 = pickle.load(f)
    res0b = lf.reduce_pair(I0, J10, bits)
    J0f = np.array([[float(x) for x in row] for row in res0b[0]])
    np.random.seed(7)
    print("[a2] reduced-matrix float64 jitter of J̃ (20 trials per δ):", flush=True)
    for delta in deltas:
        vals = []
        for t in range(20):
            J2 = J0f * (1.0 + delta * np.random.uniform(-1, 1, size=J0f.shape))
            J2 = (J2 + J2.T) / 2
            vals.append(float(np.linalg.eigvalsh(J2)[-1]))
        spread = max(vals) - min(vals)
        dv = max(abs(x - lam0) for x in vals)
        print(f"[a2] δ={delta:.0e}: spread={spread:.3e}  max|Δ|vs base={dv:.3e}  (requirement < 1e-6)", flush=True)
    from scipy.linalg import eigh as seigh
    Id = np.eye(n)
    print("[a2b] two-sided jitter (J̃+δJ, Ĩ+δI):", flush=True)
    for delta in deltas:
        vals = []
        for t in range(20):
            J2 = J0f * (1.0 + delta * np.random.uniform(-1, 1, size=J0f.shape))
            J2 = (J2 + J2.T) / 2
            I2 = Id * (1.0 + delta * np.random.uniform(-1, 1, size=n))
            I2 = (I2 + I2.T) / 2
            vals.append(float(seigh(J2, I2, eigvals_only=True)[-1]))
        spread = max(vals) - min(vals)
        print(f"[a2b] δ={delta:.0e}: spread={spread:.3e}  max|Δ|vs base={max(abs(x-lam0) for x in vals):.3e}", flush=True)

    # [b] 输入级抖动 J1 (I 精确): 全管线重算
    tasks = [(k, D, delta, seed0 + t, bits, cache) for delta in deltas for t in range(ntrials)]
    t0 = time.time()
    with mp.Pool(nproc) as pool:
        results = pool.map(fullJ_trial, tasks)
    print(f"[b] full-pipeline recompute, J1 entrywise jitter, done in {time.time()-t0:.0f}s", flush=True)
    for delta in deltas:
        rs = [r for r in results if r[0] == delta]
        oks = [r[3] for r in rs if r[2] == 'ok']
        if oks:
            spread = max(oks) - min(oks)
            dv = max(abs(x - lam0) for x in oks)
            print(f"[b] δ={delta:.0e}: λ_max trials {['%.12f' % x for x in oks]}  spread={spread:.3e}  max|Δ|vs base={dv:.3e}", flush=True)
        else:
            print(f"[b] δ={delta:.0e}: all failed", flush=True)

    # [c] RQ(v*) 输入灵敏度 (I 与 J1 都抖动)
    tasks2 = [(k, D, delta, seed0 + t, bits, z, cache) for delta in deltas for t in range(ntrials)]
    t0 = time.time()
    with mp.Pool(nproc) as pool:
        results2 = pool.map(rq_trial, tasks2)
    print(f"[c] RQ(v*) input sensitivity done in {time.time()-t0:.0f}s", flush=True)
    for delta in deltas:
        rs = [r for r in results2 if r[0] == delta]
        vals = [r[3] for r in rs if r[2] == 'ok']
        if vals:
            spread = max(vals) - min(vals)
            dv = max(abs(x - rq0) for x in vals)
            print(f"[c] δ={delta:.0e}: RQ(v*) spread={spread:.3e}  max|Δ|vs base={dv:.3e}", flush=True)

if __name__ == '__main__':
    main()
