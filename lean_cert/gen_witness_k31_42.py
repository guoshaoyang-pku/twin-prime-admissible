#!/usr/bin/env python3
"""(2) k=31..42 SAT 见证: 完整算法 C DFS 找幸存>=k 的分配"""
import sys, time
sys.path.insert(0, '.')
from cert_gen import primes_upto, survivor_count

H_TABLE = {31:140,32:146,33:152,34:156,35:158,36:162,37:168,38:176,39:182,40:186,41:188,42:196}

def find_assignment(k, d):
    """DFS 找分配 (c_p) 使幸存 >= k; 返回 assigns 或 None"""
    ps = primes_upto(k)
    def dfs(assigns, pi):
        s = survivor_count(d, assigns)
        if s < k:
            return None  # 安全剪枝: 继续分配只会减少幸存
        if pi == len(ps):
            return assigns if s >= k else None
        p = ps[pi]
        maxc = min(p - 1, d)
        # 先试"删最少"的类 (启发式: 幸存最多优先)
        cands = list(range(1, maxc + 1))
        if p > d + 1:
            cands.append(d + 1)
        cands.sort(key=lambda c: -survivor_count(d, assigns + [(p, c)]))
        for c in cands:
            r = dfs(assigns + [(p, c)], pi + 1)
            if r is not None:
                return r
        return None
    return dfs([], 0)

def admissible_check(k, t):
    ps = primes_upto(k)
    for p in ps:
        if len(set(x % p for x in t)) >= p:
            return False
    return True

for k in range(31, 43):
    H = H_TABLE[k]
    t0 = time.time()
    assigns = find_assignment(k, H)
    assert assigns is not None, f"no assignment for k={k}"
    surv = [x for x in range(H + 1) if all(x % p != c for p, c in assigns)]
    assert len(surv) >= k
    wit = sorted(surv[:k])
    ok = admissible_check(k, wit)
    assert ok, f"witness not admissible k={k}"
    assert max(wit) - min(wit) == H, f"diameter {max(wit)-min(wit)} != {H}"
    with open('witnesses_k31_42.txt', 'a') as f:
        f.write(f"k={k}  d_min={H}  witness: {','.join(map(str, wit))}  [{time.time()-t0:.2f}s]\n")
    print(f"k={k} H={H} witness OK ({time.time()-t0:.2f}s)", flush=True)
print("ALL WITNESSES DONE")
