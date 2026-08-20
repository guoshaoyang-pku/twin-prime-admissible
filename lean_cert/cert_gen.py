#!/usr/bin/env python3
"""cert_gen.py — 算法C (剩余类分配搜索) UNSAT 证书生成器原型

判定 (完备性见 verify_admissible_independent.py 算法C):
  ∃ 直径≤d 的可容许 k 元组 (平移后含 0, ⊆ [0,d])
  ⟺ ∃ 素数分配 (c_p)_{p≤k 素数}, c_p ∈ [1, p-1] (0 类被禁则不合法, 因 0 必须幸存),
    使幸存位置数 #{x ∈ [0,d] : ∀p, x mod p ≠ c_p} ≥ k.

UNSAT 证书: DFS 依次为素数 p 分配 c_p:
  - 剪枝: 部分分配后幸存 < k → 叶子 L (该分支下任何完整分配都失败)
  - 分支: 枚举 c_p ∈ [1, min(p-1,d)] (有效禁类) + 无删除类 (c_p ∈ [d+1, p-1], 合并为一支)
  全部叶子 L ⟹ (k,d) UNSAT.

证书编码 (先序, 紧凑):
  'L'                       → 叶子 (幸存 < k, 验证器重算)
  'B p <子节点×N>'          → 分支: 素数 p, N = min(p-1,d)+1 个子节点
                               (前 min(p-1,d) 个对应 c=1..min(p-1,d), 最后一个是无删除类)
"""
import sys

def primes_upto(k):
    ps = []
    for x in range(2, k + 1):
        if all(x % p for p in ps):
            ps.append(x)
    return ps

def survivor_count(d, assigns):
    cnt = 0
    for x in range(d + 1):
        ok = True
        for p, c in assigns:
            if x % p == c:
                ok = False
                break
        if ok:
            cnt += 1
    return cnt

def gen_cert(k, d):
    ps = primes_upto(k)
    stats = {'nodes': 0, 'leaves': 0, 'maxdepth': 0}

    def dfs(assigns, pi, depth):
        stats['nodes'] += 1
        stats['maxdepth'] = max(stats['maxdepth'], depth)
        s = survivor_count(d, assigns)
        if s < k:
            stats['leaves'] += 1
            return 'L'
        if pi == len(ps):
            return None  # 全部素数分配完仍幸存≥k → SAT (调用方应检测)
        p = ps[pi]
        maxc = min(p - 1, d)
        parts = []
        for c in range(1, maxc + 1):
            ch = dfs(assigns + [(p, c)], pi + 1, depth + 1)
            if ch is None:
                return None
            parts.append(ch)
        if p > d + 1:
            # 无删除类存在 (c_p ∈ [d+1, p-1] 非空), 合并为一支
            ch = dfs(assigns + [(p, d + 1)], pi + 1, depth + 1)
            if ch is None:
                return None
            parts.append(ch)
        return ('B', p, parts)

    root = dfs([], 0, 0)
    return root, stats

def serialize(node):
    if node == 'L':
        return 'L'
    _, p, parts = node
    return 'B' + str(p) + ' ' + ' '.join(serialize(ch) for ch in parts)

def verify(cert_text, k, d):
    """验证器 (与 Lean 版同逻辑): 返回 True 当且仅当证书有效 → (k,d) UNSAT"""
    ps = primes_upto(k)
    tokens = cert_text.split()
    idx = [0]

    def parse():
        t = tokens[idx[0]]
        idx[0] += 1
        if t == 'L':
            return 'L'
        p = int(t[1:])
        maxc = min(p - 1, d)
        nch = maxc + (1 if p > d + 1 else 0)
        return ('B', p, [parse() for _ in range(nch)])

    def check(node, assigns, pi):
        if node == 'L':
            return survivor_count(d, assigns) < k
        _, p, children = node
        # p 必须是下一个素数
        if pi >= len(ps) or ps[pi] != p:
            return False
        maxc = min(p - 1, d)
        for i, c in enumerate(range(1, maxc + 1)):
            if not check(children[i], assigns + [(p, c)], pi + 1):
                return False
        if p > d + 1:
            if not check(children[maxc], assigns + [(p, d + 1)], pi + 1):
                return False
        return True

    root = parse()
    if idx[0] != len(tokens):
        return False
    return check(root, [], 0)

if __name__ == '__main__':
    # 测试目标: 几个有代表性的 (k,d)
    tests = [(43, 84), (43, 198), (46, 214), (50, 98), (50, 244), (46, 216)]
    for k, d in tests:
        root, stats = gen_cert(k, d)
        if root is None:
            print(f"k={k} d={d}: SAT?! (证书生成失败)")
            continue
        txt = serialize(root)
        ok = verify(txt, k, d)
        print(f"k={k} d={d}: nodes={stats['nodes']} leaves={stats['leaves']} "
              f"depth={stats['maxdepth']} cert={len(txt)}B verify={ok}")
