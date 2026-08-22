import sys, time, pickle
import numpy as np
import gmpy2
sys.path.insert(0, '.')
import importlib.util
spec = importlib.util.spec_from_file_location("lf", "legendre_fix.py")
lf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lf)
k, D = 49, 20
with open(f'frac_cache_{k}_{D}.pkl', 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
for bits in (128, 256, 512, 1024):
    t0 = time.time()
    res = lf.reduce_pair(I, J1, bits)
    if res[0] == 'fail':
        print(f"bits={bits}: LDL FAIL at pivot {res[1][0]}", flush=True)
        continue
    V, s, L, d = res
    # cond(I) = max d / min d
    dvals = [float(x) for x in d]
    condI = max(dvals)/min(dvals)
    Jtf = np.array([[float(x) for x in row] for row in V])
    ev = np.linalg.eigvalsh(Jtf)
    print(f"bits={bits}: λ_max = {ev[-1]:.15f}  M = {k*ev[-1]:.10f}  cond(I) = {condI:.3e}  ({time.time()-t0:.0f}s)", flush=True)
