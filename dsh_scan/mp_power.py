"""mpmath 高精度幂法: λ_max(J1, I) 的高精度数值 (无 LU)"""
import sys, time, pickle
from fractions import Fraction as Fr
import mpmath as mp

def load_frac(k, D):
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    return I, J1

def power_iter(k, D, digits=80, max_iter=500, tol=1e-40):
    mp.mp.dps = digits
    I, J1 = load_frac(k, D)
    n = len(I)
    print(f"k={k} D={D} n={n} digits={digits}", flush=True)
    # 转 mpmath 矩阵
    t0 = time.time()
    Im = mp.matrix(n, n)
    Jm = mp.matrix(n, n)
    for i in range(n):
        for j in range(n):
            Im[i, j] = mp.mpf(I[i][j].numerator) / mp.mpf(I[i][j].denominator)
            Jm[i, j] = mp.mpf(J1[i][j].numerator) / mp.mpf(J1[i][j].denominator)
    print(f"convert: {time.time()-t0:.1f}s", flush=True)
    # 预热: float 特征向量 (scipy 广义) → mpmath
    import numpy as np
    import scipy.linalg as sla
    Ifl = np.array([[float(x) for x in row] for row in I])
    Jfl = np.array([[float(x) for x in row] for row in J1])
    d = 1.0/np.sqrt(np.maximum(np.diag(Ifl), 1e-300))
    Isc = Ifl*d[:,None]*d[None,:] + 1e-13*np.eye(n)
    Jsc = Jfl*d[:,None]*d[None,:]
    w, V = sla.eigh(Jsc, Isc)
    x0 = V[:, -1] * d  # 最大特征向量 (未缩放)
    x = mp.matrix(n, 1)
    for i in range(n):
        x[i, 0] = mp.mpf(x0[i])
    # 幂法 (I-内积归一化)
    lam = mp.mpf(0)
    for it in range(max_iter):
        y = Jm * x
        # λ = x^T y / x^T I x
        num = (x.T * y)[0, 0]
        den = (x.T * (Im * x))[0, 0]
        lam_new = num / den
        # 归一化 (I-内积): x <- y / sqrt(y^T I y)
        yn = (y.T * (Im * y))[0, 0]
        x = y / mp.sqrt(yn)
        if abs(lam_new - lam) < tol:
            lam = lam_new
            break
        lam = lam_new
        if it % 50 == 0:
            print(f"  iter {it}: M~{float(k*lam):.12f}", flush=True)
    print(f"RESULT k={k}: lambda_max~{mp.nstr(lam, 30)}  M~{mp.nstr(k*lam, 30)}  (iters={it+1}, total {time.time()-t0:.0f}s)", flush=True)

if __name__ == "__main__":
    k, D = int(sys.argv[1]), int(sys.argv[2])
    power_iter(k, D)
