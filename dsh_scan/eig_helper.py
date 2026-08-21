"""辅助: 精确 Fraction 矩阵的稳健特征值 (scipy 广义 / eigh 截断)"""
import sys, pickle, numpy as np
import scipy.linalg as sla

def load_frac(k, D):
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    n = len(I)
    Ifl = np.array([[float(x) for x in row] for row in I])
    Jfl = np.array([[float(x) for x in row] for row in J1])
    return Ifl, Jfl, n

def eig_generalized(I, J, k):
    n = len(I)
    d = 1.0/np.sqrt(np.maximum(np.diag(I), 1e-300))
    Isc = I*d[:,None]*d[None,:]
    Jsc = J*d[:,None]*d[None,:]
    # 方法1: scipy 广义特征值 (Jsc x = lam * Isc x)
    for jit in [0, 1e-13, 1e-11]:
        try:
            I2 = Isc + jit*np.eye(n)
            w = sla.eigh(Jsc, I2, eigvals_only=True)
            print(f"[generalized jit={jit}] M~={k*w[-1]:.6f}  (min eig of I: {np.linalg.eigvalsh(I2)[0]:.3e})", flush=True)
            return
        except Exception as e:
            print(f"[generalized jit={jit}] failed: {type(e).__name__}", flush=True)
    # 方法2: eigh(I) 截断
    wI, U = np.linalg.eigh(Isc)
    wmax = wI[-1]
    for cutoff in [1e-10, 1e-12, 1e-14]:
        keep = wI > cutoff * wmax
        m = keep.sum()
        if m < 2:
            continue
        Uc = U[:, keep]
        B = Uc.T @ Jsc @ Uc
        Dinv = 1.0/np.sqrt(wI[keep])
        B2 = Dinv[:,None]*B*Dinv[None,:]
        ev = np.linalg.eigvalsh(B2)
        print(f"[truncate cutoff={cutoff:.0e} rank={m}/{n}] M~={k*ev[-1]:.6f}", flush=True)

if __name__ == "__main__":
    k, D = int(sys.argv[1]), int(sys.argv[2])
    I, J, n = load_frac(k, D)
    print(f"k={k} D={D} n={n}", flush=True)
    eig_generalized(I, J, k)
