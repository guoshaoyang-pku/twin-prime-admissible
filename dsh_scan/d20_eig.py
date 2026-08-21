"""D=20 特征值: 增强扰动版 (病态矩阵)"""
import sys, numpy as np

def lambda_max_robust(I, J1, jitter=1e-9):
    n = len(I)
    Ifl = np.array(I, dtype=float)
    Jfl = np.array(J1, dtype=float)
    d = 1.0 / np.sqrt(np.maximum(np.diag(Ifl), 1e-300))
    Isc = Ifl * d[:, None] * d[None, :]
    Jsc = Jfl * d[:, None] * d[None, :]
    Isc = Isc + jitter * np.eye(n)
    try:
        L = np.linalg.cholesky(Isc)
    except np.linalg.LinAlgError:
        Isc = Isc + 1e-6 * np.eye(n)
        L = np.linalg.cholesky(Isc)
    Linv = np.linalg.solve(L, np.eye(n))
    B = Linv @ Jsc @ Linv.T
    ev = np.linalg.eigvalsh(B)
    return float(ev[-1])

if __name__ == "__main__":
    import pickle, time
    k = int(sys.argv[1])
    with open(f'd20_par_{k}_mat.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    t0 = time.time()
    for jit in [1e-9, 1e-8, 1e-7]:
        try:
            lam = lambda_max_robust(I, J1, jit)
            print(f"k={k} D=20 jitter={jit}: lambda_max~={lam:.9f}  M~={k*lam:.6f}  ({(time.time()-t0):.0f}s)", flush=True)
            break
        except np.linalg.LinAlgError as e:
            print(f"jitter={jit} failed", flush=True)
