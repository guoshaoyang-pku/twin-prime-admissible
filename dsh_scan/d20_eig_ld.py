"""longdouble 高精度特征值"""
import sys, numpy as np

def lambda_max_ld(I, J1, jitter=1e-12):
    n = len(I)
    Ifl = np.array(I, dtype=np.longdouble)
    Jfl = np.array(J1, dtype=np.longdouble)
    d = 1.0 / np.sqrt(np.maximum(np.diag(Ifl), 1e-300))
    Isc = Ifl * d[:, None] * d[None, :]
    Jsc = Jfl * d[:, None] * d[None, :]
    Isc = Isc + jitter * np.eye(n, dtype=np.longdouble)
    try:
        L = np.linalg.cholesky(Isc)
    except np.linalg.LinAlgError:
        Isc = Isc + 1e-9 * np.eye(n, dtype=np.longdouble)
        L = np.linalg.cholesky(Isc)
    Linv = np.linalg.solve(L, np.eye(n, dtype=np.longdouble))
    B = Linv @ Jsc @ Linv.T
    ev = np.linalg.eigvalsh(B)
    return float(ev[-1])

if __name__ == "__main__":
    import pickle, time
    k = int(sys.argv[1])
    with open(f'd20_par_{k}_mat.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    t0 = time.time()
    for jit in [1e-12, 1e-10]:
        try:
            lam = lambda_max_ld(I, J1, jit)
            print(f"k={k} D=20 longdouble jitter={jit}: lambda_max~={lam:.9f}  M~={k*lam:.6f}  ({(time.time()-t0):.0f}s)", flush=True)
            break
        except np.linalg.LinAlgError as e:
            print(f"jitter={jit} failed", flush=True)
