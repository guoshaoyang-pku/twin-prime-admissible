import sys, pickle
sys.path.insert(0, '..')
import importlib.util
spec = importlib.util.spec_from_file_location("mps", "../mk_probe_strict.py")
mps = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mps)
ldl_sign = mps.ldl_sign
with open('frac_cache_49_20.pkl', 'rb') as f:
    I, J1 = pickle.load(f)
n = len(I)
def has_pos(mid):
    Am = [[J1[i][j] - mid * I[i][j] for j in range(n)] for i in range(n)]
    pv = ldl_sign(Am)
    if pv is None:
        return 'zero_pivot'
    return any(pv)
for mid in (0.0, 0.05, 0.079, 0.07981, 0.0817, 0.09, 1.0):
    print(f"mid={mid:.15g}: has_pos = {has_pos(mid)}", flush=True)
