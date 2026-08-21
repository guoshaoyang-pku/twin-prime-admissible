"""D=20 并行版: 并行 H 构建 + 并行矩阵"""
import sys, time
import numpy as np
sys.path.insert(0, '.')
sys.path.insert(0, 'dsh_scan')
import floatbuild as fb
import floatbuild_par as fbp

def gen_multisets(max_deg, max_parts, min_val=1):
    res = {}
    def rec(deg_used, parts, last):
        key = tuple(parts)
        res[key] = sum(parts)
        for v in range(last, max_deg - deg_used + 1):
            if len(parts) < max_parts:
                rec(deg_used + v, parts + [v], v)
    rec(0, [], min_val)
    return res

def h_worker(args):
    coords, keys = args
    cache = {}
    for key in keys:
        fb.H_of_float(list(key), coords, cache)
    return coords, cache

def main():
    k = int(sys.argv[1]); D = int(sys.argv[2])
    nproc = int(sys.argv[3]) if len(sys.argv) > 3 else 24
    eps_f = 1/25; r = 6
    t0 = time.time()
    basis_list = sorted(gen_multisets(D, D), key=lambda kk: (sum(kk), kk))
    print(f"k={k} D={D} basis n={len(basis_list)}", flush=True)
    # 并行 H 构建 (按 coords × key 分块)
    import multiprocessing as mp
    t1 = time.time()
    ms = list(gen_multisets(2 * D, 2 * D).keys())
    chunks = [[] for _ in range(nproc)]
    for i, key in enumerate(ms):
        chunks[i % nproc].append(key)
    H_cache = {}
    with mp.Pool(nproc) as pool:
        for coords, cache in pool.map(h_worker, [(k, chunks[i]) for i in range(nproc)]):
            if coords == k:
                H_cache.update(cache)
        # k-1 的 H 单独构建 (与 k 不同)
    H_cache2 = {}
    with mp.Pool(nproc) as pool:
        for coords, cache in pool.map(h_worker, [(k - 1, chunks[i]) for i in range(nproc)]):
            if coords == k - 1:
                H_cache2.update(cache)
    H_cache.update(H_cache2)
    print(f"H cache: {len(H_cache)} entries ({(time.time()-t1):.0f}s)", flush=True)
    t2 = time.time()
    I, J1 = fbp.build_matrices_float_par(k, eps_f, r, basis_list, H_cache, nproc)
    print(f"build: {(time.time()-t2):.0f}s", flush=True)
    import pickle
    with open(f'd20_par_{k}_mat.pkl', 'wb') as f:
        pickle.dump((I, J1), f)
    t3 = time.time()
    try:
        lam = fb.float_lambda_max(I, J1)
        print(f"k={k} eps=1/25 D={D} r=6 n={len(basis_list)}: lambda_max~={lam:.9f}  M~={k*lam:.6f}  (eig {(time.time()-t3):.0f}s)", flush=True)
    except np.linalg.LinAlgError:
        print("eig failed (Cholesky), matrix saved for d20_eig.py", flush=True)
    print(f"TOTAL {(time.time()-t0):.0f}s", flush=True)

if __name__ == "__main__":
    main()
