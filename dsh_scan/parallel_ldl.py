#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""parallel_ldl.py — 并行扇出 LDL^T 判定 (multiprocessing)
每轮把区间分成 S 段, S 个进程并行判定 λ_max > mid_i (ldl_sign),
定位 λ 所在段, 递归细分。
用法: python3 parallel_ldl.py k D eps_num eps_den [S] [rounds]
"""
import sys, time, pickle, os
from fractions import Fraction as Fr
import multiprocessing as mp

sys.path.insert(0, '..')
import importlib.util
spec = importlib.util.spec_from_file_location("mps", "../mk_probe_strict.py")
mps = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mps)
ldl_sign = mps.ldl_sign

_IM = None
_JM = None

def _init(I, J1):
    global _IM, _JM
    _IM = I
    _JM = J1

def _judge(mid):
    n = len(_IM)
    Am = [[_JM[i][j] - mid * _IM[i][j] for j in range(n)] for i in range(n)]
    pv = ldl_sign(Am)
    if pv is None:
        return None
    return any(pv)

def main():
    t0 = time.time()
    k = int(sys.argv[1]); D = int(sys.argv[2])
    en = int(sys.argv[3]); ed = int(sys.argv[4])
    S = int(sys.argv[5]) if len(sys.argv) > 5 else 48
    rounds = int(sys.argv[6]) if len(sys.argv) > 6 else 3
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    print(f"parallel_ldl k={k} D={D} n={n} S={S} rounds={rounds}", flush=True)
    eps = Fr(en, ed)
    lo = Fr(0)
    hi = Fr(4, k)
    # 全局初始化 (fork 继承)
    global _IM, _JM
    _IM = I
    _JM = J1
    pool = mp.Pool(S, initializer=_init, initargs=(I, J1))
    for rd in range(rounds):
        t1 = time.time()
        # S 个端点 mid_i = lo + (i+1)/S*(hi-lo)
        mids = [lo + Fr(i + 1, S) * (hi - lo) for i in range(S)]
        results = pool.map(_judge, mids)
        # 找最小的 i 使 judge(mid_i) = True (λ > mid_i)
        idx = None
        for i, r in enumerate(results):
            if r:
                idx = i
                break
        if idx is None:
            # 全部 False: λ ≤ 所有 mid → hi = 最左端点 (mid_0)
            hi = mids[0]
        elif idx == 0:
            # 第一个就 True: λ > mid_0 → lo = mid_0
            lo = mids[0]
        else:
            # λ ∈ (mid_{idx-1}, mid_idx]
            lo = mids[idx - 1]
            hi = mids[idx]
        print(f"  round {rd}: lambda in ({float(lo):.10f}, {float(hi):.10f}) ({time.time()-t1:.0f}s)", flush=True)
    pool.close()
    print(f"RESULT k={k} eps={eps} D={D}: lambda_max in ({float(lo):.12f}, {float(hi):.12f})  "
          f"M in ({float(k*lo):.8f}, {float(k*hi):.8f})  (total {time.time()-t0:.0f}s)", flush=True)

if __name__ == '__main__':
    main()
