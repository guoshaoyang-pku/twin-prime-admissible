"""并行版：H 预计算用多进程，然后严格二分 λ_max"""
import sys, math
sys.path.insert(0, '.')
import importlib.util
from multiprocessing import Pool
spec = importlib.util.spec_from_file_location("s", "mk_probe_strict.py")
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)
from fractions import Fraction as Fr

def compute_H(args):
    parts, coords = args
    cache = {}
    return (tuple(sorted(parts)), coords), s.H_of(list(parts), coords, cache)

def main():
    k = int(sys.argv[1]); en = int(sys.argv[2]); ed = int(sys.argv[3])
    D = int(sys.argv[4]); P = int(sys.argv[5]); r = int(sys.argv[6]) if len(sys.argv) > 6 else 6
    iters = int(sys.argv[7]) if len(sys.argv) > 7 else 50
    nproc = int(sys.argv[8]) if len(sys.argv) > 8 else 48
    eps = Fr(en, ed)
    basis = sorted(s.gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    keys = list(s.gen_multisets(2*D, 2*P))
    tasks = [(list(key), c) for c in (k, k-1) for key in keys]
    print(f"预计算 {len(tasks)} 个 H（{nproc} 进程并行）...", flush=True)
    with Pool(nproc) as pool:
        results = pool.map(compute_H, tasks)
    H_cache = dict(results)
    print("H 预计算完成", flush=True)
    I, J1 = s.build_matrices(k, eps, r, basis, H_cache)
    n = len(basis)
    lo, hi = Fr(0), Fr(4, k)
    for _ in range(iters):
        mid = (lo + hi) / 2
        A = [[J1[i][j] - mid*I[i][j] for j in range(n)] for i in range(n)]
        piv = s.ldl_sign(A)
        if piv is None:
            lo = hi = mid
            break
        if any(piv): lo = mid
        else: hi = mid
    print(f"k={k} eps={eps} D={D} n={n}: λ_max ∈ ({float(lo):.12f}, {float(hi):.12f})  M ∈ ({float(k*lo):.10f}, {float(k*hi):.10f})", flush=True)

if __name__ == "__main__":
    main()
