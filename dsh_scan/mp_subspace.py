"""子空间投影 (float): 顶部 m 个特征向量 → 小广义特征值 → 高精度下界"""
import sys, time, pickle
import numpy as np
import scipy.linalg as sla

def load_frac(k, D):
    with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
        I, J1 = pickle.load(f)
    return I, J1

def subspace(k, D, m=64):
    I, J1 = load_frac(k, D)
    n = len(I)
    Ifl = np.array([[float(x) for x in row] for row in I])
    Jfl = np.array([[float(x) for x in row] for row in J1])
    d = 1.0/np.sqrt(np.maximum(np.diag(Ifl), 1e-300))
    Isc = Ifl*d[:,None]*d[None,:] + 1e-13*np.eye(n)
    Jsc = Jfl*d[:,None]*d[None,:]
    w, V = sla.eigh(Jsc, Isc)
    Vm = V[:, -m:] * d[:, None]
    A = Vm.T @ Jfl @ Vm
    B = Vm.T @ Ifl @ Vm
    wm = sla.eigh(A, B, eigvals_only=True)
    print(f"k={k} D={D} subspace m={m}: M~{k*wm[-1]:.10f}", flush=True)
    return float(k*wm[-1])

if __name__ == "__main__":
    k, D = int(sys.argv[1]), int(sys.argv[2])
    m = int(sys.argv[3]) if len(sys.argv) > 3 else 64
    subspace(k, D, m)
