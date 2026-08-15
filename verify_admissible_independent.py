#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_admissible_independent.py
================================================================================
可容许 k 元组最小直径 H(k) 关键值的**独立交叉验证**脚本。

设计原则: 与现有 C 程序 (admissible*.c: "偶数池 + 频数剪枝 DFS") 以及
Lean 的 native_decide 走完全不同的算法路径, 从而独立增强证明可信度。

三套独立算法:
  [SAT 侧]  算法A: 逐素数剩余类直接检查 (双实现: 集合计数 vs 频数计数, 互相对拍)
  [UNSAT侧] 算法B: 朴素子集穷举 (只做基本剪枝: 平移归约 + 奇偶归约 + 失败即回溯;
                    不做任何频数/前瞻剪枝) —— 用于 k=2..12 的 H(k) 精确穷举
  [UNSAT侧] 算法C: 剩余类分配搜索 (集合覆盖视角, 用户方案A/B):
                    对每个素数 p<=k 选一个"被禁止"的剩余类 c_p,
                    幸存位置 = {v in [0,d] : 对一切 p, v mod p != c_p};
                    存在可容许 k 元组(直径<=d) 当且仅当 存在分配使幸存位置数 >= k。
                    搜索空间是 分配空间 prod(p) 而非 位置子集空间 C(d,k),
                    剪枝依据是"幸存位置单调递减", 与 C 程序的频数剪枝完全不同。
                    —— 用于 k=20, k=30, k=42, k=46, k=50 的边界局部抽查。

完备性引理 (算法C): T 可容许且直径<=d  => 平移使 min(T)=0, 则 T' 含于 [0,d];
对每个素数 p<=k, T' 模 p 不覆盖全部类, 故存在空类 c_p, 于是 T' 的每个元素都避开
所有 c_p, 即 T' 含于幸存集合 U, |U| >= k。反过来, 若 |U| >= k, 任取 U 的 k 元子集
S, 对每个素数 p<=k, S 模 p 至多覆盖 p-1 个类 (类 c_p 必空), 故 S 可容许且直径<=d。
奇偶性: 可容许元组模 2 不能覆盖两类, 故全为同奇偶; 平移后 min=0 => 全为偶数,
因此 H(k) 为偶数, 算法B 只需枚举偶数子集, 算法C 无需额外处理 (2 的类自动体现)。

用法:
    python3 verify_admissible_independent.py [--quick]
    (默认跑全部; --quick 只跑 SAT 侧 + k=2..12 穷举, 跳过较大的边界抽查)

输出: 全中文报告 (stdout), 同时写入 verify_admissible_independent.log
================================================================================
"""
import json
import re
import sys
import time

# ----------------------------------------------------------------------------
# 基础工具: 素数表
# ----------------------------------------------------------------------------
def _sieve(n):
    s = [True] * (n + 1)
    if n >= 0:
        s[0] = False
    if n >= 1:
        s[1] = False
    for i in range(2, int(n ** 0.5) + 1):
        if s[i]:
            for j in range(i * i, n + 1, i):
                s[j] = False
    return [i for i in range(n + 1) if s[i]]

PRIMES = _sieve(64)          # k<=50 需要素数 <= 50
PRIME_CACHE = {}
def primes_le(k):
    if k not in PRIME_CACHE:
        PRIME_CACHE[k] = [p for p in PRIMES if p <= k]
    return PRIME_CACHE[k]

# ----------------------------------------------------------------------------
# [SAT 侧] 算法A: 逐素数剩余类直接检查 (两个独立实现, 互相对拍)
#   与 Lean 定义一致: 对每个素数 p<=k, 元组模 p 的剩余类数 < p。
# ----------------------------------------------------------------------------
def is_admissible_set(k, tup):
    """实现1: 集合计数 —— 剩余类集合的基数 < p 才算通过。"""
    for p in primes_le(k):
        if len({v % p for v in tup}) == p:
            return False, p
    return True, None

def is_admissible_freq(k, tup):
    """实现2: 频数计数 —— 统计每个剩余类被覆盖的次数; 存在 0 覆盖(空类)才通过。
    与实现1 代码路径完全不同 (数组计数 vs 集合基数)。"""
    for p in primes_le(k):
        freq = [0] * p
        for v in tup:
            freq[v % p] += 1
        if 0 not in freq:          # 每个剩余类都被覆盖 => 覆盖全部 p 类 => 不可容许
            return False, p
    return True, None

def check_tuple(k, tup, d_claimed=None):
    """对单个候选元组做全套结构性检查 + 双实现可容许性检查。
    返回 (ok, reason_dict)。"""
    tup = list(tup)
    r = {}
    r['len'] = len(tup)
    r['distinct'] = len(set(tup)) == len(tup)
    r['ascending'] = all(tup[i] < tup[i + 1] for i in range(len(tup) - 1))
    r['min'] = min(tup) if tup else None
    r['max'] = max(tup) if tup else None
    r['diam'] = (max(tup) - min(tup)) if tup else 0
    r['k_ok'] = (r['len'] == k)
    r['d_ok'] = (d_claimed is None) or (r['diam'] == d_claimed)
    a1, p1 = is_admissible_set(k, tup)
    a2, p2 = is_admissible_freq(k, tup)
    r['adm_set'] = a1
    r['adm_freq'] = a2
    r['adm_agree'] = (a1 == a2)
    r['bad_p_set'] = p1
    r['bad_p_freq'] = p2
    r['ok'] = (r['k_ok'] and r['distinct'] and r['d_ok'] and a1 and a2 and r['adm_agree'])
    return r

# ----------------------------------------------------------------------------
# 数据加载: sorted_witnesses.json (字符串化列表) + Lean 文件中的 k44/k45 见证
# ----------------------------------------------------------------------------
JSON_PATH = "sorted_witnesses.json"
LEAN_PATH = "TwinPrimeAdmissible.lean"

# k44/k45 见证在 Lean 中 (json 里没有), 直接取自 TwinPrimeAdmissible.lean 第 1101/1113 行
LEAN_ONLY_WITNESSES = {
    "k44_d210": json.loads("[0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210]"),
    "k45_d212": json.loads("[0, 2, 6, 8, 12, 18, 20, 26, 30, 32, 36, 42, 48, 50, 56, 62, 68, 72, 78, 86, 90, 96, 98, 102, 110, 116, 120, 128, 132, 138, 140, 146, 152, 156, 158, 162, 168, 176, 182, 186, 188, 198, 200, 210, 212]"),
}

def load_witnesses():
    """返回 [(name, k, d_claimed, tup), ...]"""
    out = []
    with open(JSON_PATH, encoding="utf-8") as f:
        data = json.load(f)
    for name, s in data.items():
        tup = json.loads(s)          # json 里是字符串化的列表
        if name.startswith("small_"):
            k = int(name.split("_")[1][1:])
            d = None                 # 直径由 max-min 计算
        else:
            m = re.match(r"k(\d+)_d(\d+)", name)
            k = int(m.group(1)); d = int(m.group(2))
        out.append((name, k, d, tup))
    for name, tup in LEAN_ONLY_WITNESSES.items():
        m = re.match(r"k(\d+)_d(\d+)", name)
        k = int(m.group(1)); d = int(m.group(2))
        out.append((name, k, d, tup))
    return out

def load_witnesses_txt():
    """解析 witnesses.txt (C 程序输出的 k=2..30 d_min 见证表)。"""
    out = []
    with open("witnesses.txt", encoding="utf-8") as f:
        for line in f:
            m = re.match(r"k=\s*(\d+)\s+d_min=(\d+)\s+witness:\s*(.*?)\s*\[", line)
            if not m:
                continue
            k, d, body = int(m.group(1)), int(m.group(2)), m.group(3)
            tup = [int(x) for x in body.split(",")]
            out.append((f"txt_k{k}_d{d}", k, d, tup))
    return out

def load_lean_defs():
    """解析 Lean 文件中的 witness_* 定义, 用于 json 与 Lean 一致性对拍。"""
    defs = {}
    with open(LEAN_PATH, encoding="utf-8") as f:
        text = f.read()
    for m in re.finditer(r"def\s+(witness(?:_k\d+_d\d+|46_d\d+|_k\d+))\s*:\s*List Nat\s*:=\s*\[([^\]]*)\]", text):
        name, body = m.group(1), m.group(2)
        vals = [int(x) for x in re.findall(r"\d+", body)]
        defs[name] = vals
    return defs

# ----------------------------------------------------------------------------
# [UNSAT 侧] 算法B: 朴素子集穷举 (只做基本剪枝)
#   完备性: 平移归约 (min=0) + 奇偶归约 (全为偶数) + 逐层"已覆盖类数 < p"失败即回溯。
#   没有任何频数/前瞻/后缀计数剪枝 —— 与 C 程序的核心剪枝机制刻意不同。
# ----------------------------------------------------------------------------
class BudgetExceeded(Exception):
    pass

def hk_naive(k, max_d=400, budget_s=600):
    """对偶数 d 从 0 向上扫描, 返回 (H(k), 见证元组) 或 (None, reason)。"""
    ps = primes_le(k)
    t0 = time.time()
    for d in range(0, max_d + 1, 2):
        cands = list(range(2, d + 1, 2))     # 含 0 的可容许元组必全为偶数
        sol = [0]
        masks = [1] * len(ps)                 # 0 mod p == 0, 类 0 已被覆盖
        found = None
        # 递归: 只做基本剪枝 (剩余候选不足 / 增量可容许性失败即回溯)
        def dfs(idx, need):
            nonlocal found
            if found is not None:
                return
            if time.time() - t0 > budget_s:
                raise BudgetExceeded(f"k={k} d={d} 超时")
            if len(cands) - idx < need:
                return
            if need == 0:
                found = tuple(sol)
                return
            for i in range(idx, len(cands) - need + 1):
                v = cands[i]
                ok = True
                for j, p in enumerate(ps):
                    bit = masks[j]
                    r = v % p
                    if bit >> r & 1:
                        continue
                    if bit.bit_count() + 1 >= p:   # 覆盖全部 p 类 => 不可容许
                        ok = False
                        break
                if not ok:
                    continue
                prev = masks.copy()            # 快照恢复, 避免误清早已覆盖的类
                for j, p in enumerate(ps):
                    masks[j] |= 1 << (v % p)
                sol.append(v)
                dfs(i + 1, need - 1)
                sol.pop()
                masks[:] = prev
        try:
            dfs(0, k - 1)
        except BudgetExceeded as e:
            return None, str(e)
        if found is not None:
            return d, found
    return None, f"max_d={max_d} 内未找到"

# ----------------------------------------------------------------------------
# [UNSAT 侧] 算法C: 剩余类分配搜索 (集合覆盖视角)
#   存在可容许 k 元组(直径<=d)  <=> 存在 (c_p) 使幸存位置数 >= k  (见文件头引理)
#   搜索空间: 分配 (c_p) 的积空间; 剪枝: 幸存位置数单调递减, < k 即剪。
# ----------------------------------------------------------------------------
class AssignmentSearch:
    def __init__(self, k, d, budget_s=120.0):
        self.k = k
        self.d = d
        self.ps = primes_le(k)
        self.budget = budget_s
        self.nodes = 0
        self.t0 = time.time()

    def search(self):
        """返回 (True, witness) 或 (False, None) 或抛出 BudgetExceeded。"""
        surv = list(range(self.d + 1))
        return self._dfs(0, surv)

    def _dfs(self, level, surv):
        self.nodes += 1
        if time.time() - self.t0 > self.budget:
            raise BudgetExceeded(f"k={self.k} d={self.d} 超时 (nodes={self.nodes})")
        if len(surv) < self.k:
            return False, None
        if level == len(self.ps):
            return True, surv[:self.k]
        p = self.ps[level]
        for c in range(p):                     # 对素数 p 选择被禁止的类 c
            ns = [v for v in surv if v % p != c]
            if len(ns) >= self.k:              # 幸存位置单调递减 => 可安全剪枝
                r = self._dfs(level + 1, ns)
                if r[0]:
                    return r
        return False, None

def sat_le_d(k, d, budget_s=120.0):
    """完备判定: 存在可容许 k 元组且直径 <= d ? 返回 (bool, witness, nodes)。"""
    s = AssignmentSearch(k, d, budget_s)
    try:
        ok, w = s.search()
        return ok, w, s.nodes
    except BudgetExceeded as e:
        return None, str(e), s.nodes

# ----------------------------------------------------------------------------
# 小工具: 随机性质测试 (集合实现 vs 频数实现 一致性)
# ----------------------------------------------------------------------------
import random
def property_test(n=2000, seed=20240815):
    random.seed(seed)
    disagree = 0
    for _ in range(n):
        k = random.randint(2, 24)
        tup = sorted(random.sample(range(0, 300), k))
        a1, _ = is_admissible_set(k, tup)
        a2, _ = is_admissible_freq(k, tup)
        if a1 != a2:
            disagree += 1
    return disagree

# ----------------------------------------------------------------------------
# 主流程
# ----------------------------------------------------------------------------
def fmt_ok(b):
    return "PASS" if b else "FAIL"

def main():
    quick = "--quick" in sys.argv
    log = open("verify_admissible_independent.log", "w", encoding="utf-8")
    def P(*a):
        line = " ".join(str(x) for x in a)
        print(line)
        log.write(line + "\n")
        log.flush()

    t_start = time.time()
    P("=" * 88)
    P("独立交叉验证报告: 可容许 k 元组最小直径 H(k) 关键值")
    P("脚本: verify_admissible_independent.py  (Python %d.%d)" % sys.version_info[:2])
    P("数据: sorted_witnesses.json + TwinPrimeAdmissible.lean (k44/k45 见证)")
    P("=" * 88)

    # ------------------------- 0. 性质自检 -------------------------
    P("\n[0] 算法A 双实现一致性随机性质测试 (2000 随机元组, seed=20240815)")
    dg = property_test()
    P(f"    集合计数 vs 频数计数 不一致数: {dg}  {'PASS' if dg == 0 else 'FAIL'}")

    # ------------------------- 1. SAT 侧 -------------------------
    P("\n" + "=" * 88)
    P("[1] SAT 侧: 见证元组独立验证 (逐素数剩余类检查, 双实现对拍)")
    P("=" * 88)
    P(f"{'见证名称':<14}{'k':>4}{'声明d':>7}{'实际长':>7}{'互异':>6}{'升序':>6}"
      f"{'min':>5}{'max':>5}{'直径':>6}{'直径=d':>7}{'可容许':>8}{'双实现一致':>10}  结论")
    all_ok = True
    results = []
    for name, k, d_claimed, tup in load_witnesses():
        r = check_tuple(k, tup, d_claimed)
        adm = r['adm_set']
        verdict = "PASS" if r['ok'] else "FAIL"
        if not r['ok']:
            all_ok = False
        results.append((name, k, d_claimed, r, verdict))
        P(f"{name:<14}{k:>4}{(str(d_claimed) if d_claimed is not None else '-'):>7}"
          f"{r['len']:>7}{fmt_ok(r['distinct']):>6}{fmt_ok(r['ascending']):>6}"
          f"{r['min']:>5}{r['max']:>5}{r['diam']:>6}{fmt_ok(r['d_ok']):>7}"
          f"{fmt_ok(adm):>8}{fmt_ok(r['adm_agree']):>10}  {verdict}"
          + (f"  [k长度不符: {r['len']} vs {k}]" if not r['k_ok'] else "")
          + (f"  [直径不符: {r['diam']} vs {d_claimed}]" if not r['d_ok'] else "")
          + (f"  [模{r['bad_p_set']}覆盖全部类]" if not adm else ""))

    # 重点: k50_d246 专项检查
    for name, k, d_claimed, r, verdict in results:
        if name == "k50_d246":
            P("\n[1a] k50_d246 专项检查:")
            P(f"    长度 = {r['len']} (要求 50):  {'PASS' if r['len'] == 50 else 'FAIL'}")
            P(f"    max-min = {r['diam']} (要求 246):  {'PASS' if r['diam'] == 246 else 'FAIL'}")
            P(f"    min={r['min']}, max={r['max']}, 互异={r['distinct']}, 升序={r['ascending']}")
            P(f"    可容许性: {'PASS' if r['adm_set'] else 'FAIL'}")

    # json 与 Lean 一致性对拍
    P("\n[1b] sorted_witnesses.json 与 TwinPrimeAdmissible.lean 定义一致性对拍:")
    lean_defs = load_lean_defs()
    name_map = {"k43_d200": "witness_k43_d200", "k46_d216": "witness_k46_d216",
                "k47_d226": "witness_k47_d226", "k48_d236": "witness_k48_d236",
                "k49_d240": "witness_k49_d240", "k50_d246": "witness_k50_d246",
                "k44_d210": "witness_k44_d210", "k45_d212": "witness_k45_d212"}
    name_map.update({f"k46_d{d}": f"witness46_d{d}" for d in
                     [246, 244, 242, 240, 238, 236, 234, 232, 230, 228, 226, 222, 218]})
    name_map.update({f"small_k{k}": f"witness_k{k}" for k in range(2, 13)})
    json_tups = {n: t for n, _, _, t in load_witnesses()}
    lean_checked = 0
    for jname, lname in name_map.items():
        if jname not in json_tups or lname not in lean_defs:
            continue
        jtup = json_tups[jname]
        same = (jtup == lean_defs[lname])
        lean_checked += 1
        if not same:
            all_ok = False
        P(f"    {jname:<12} vs Lean {lname:<18}: {'一致 PASS' if same else '不一致 FAIL'}")
    P(f"    共对拍 {lean_checked} 组")

    # witnesses.txt (C 程序 k=2..30 d_min 表) 的 SAT 侧复核
    P("\n[1c] witnesses.txt (C 程序 k=2..30 d_min 见证表) 独立复核:")
    txt_all_ok = True
    for name, k, d, tup in load_witnesses_txt():
        r = check_tuple(k, tup, d)
        if not r['ok']:
            txt_all_ok = False
        P(f"    {name:<14} k={k:>2} d_min={d:>3}: 长度{r['len']} 直径{r['diam']} "
          f"可容许{fmt_ok(r['adm_set'])}  {fmt_ok(r['ok'])}")
    P(f"    witnesses.txt 复核: {'全部 PASS' if txt_all_ok else '存在 FAIL'}")

    # ------------------------- 2. UNSAT 侧: k=2..12 精确穷举 -------------------------
    P("\n" + "=" * 88)
    P("[2] UNSAT 侧 (算法B 朴素穷举): 精确计算 H(k), k=2..12")
    P("    方法: 对每个偶数 d 枚举含 0 的偶数 k 子集 (平移+奇偶归约, 无频数剪枝)")
    P("=" * 88)
    known = {2: 2, 3: 6, 4: 8, 5: 12, 6: 16, 7: 20, 8: 26, 9: 30, 10: 32, 11: 36, 12: 42}
    P(f"{'k':>4}{'H(k) 独立穷举':>14}{'已知(A008407)':>14}{'一致':>6}  见证")
    naive_ok = True
    naive_results = {}
    for k in range(2, 13):
        h, w = hk_naive(k, budget_s=300)
        known_v = known[k]
        if h is None:
            naive_ok = False
            P(f"{k:>4}{'超时/失败':>14}{known_v:>14}{'FAIL':>6}  {w}")
            continue
        ok = (h == known_v)
        if not ok:
            naive_ok = False
        naive_results[k] = (h, w)
        # 验证找到的见证直径确实 = h (min=0, max=h)
        assert w[0] == 0 and max(w) == h, f"内部断言失败 k={k}"
        P(f"{k:>4}{h:>14}{known_v:>14}{'PASS' if ok else 'FAIL':>6}  {list(w)}")

    # ------------------------- 3. 算法B 扩展: k=13..20 (尽力而为) -------------------------
    P("\n" + "=" * 88)
    P("[3] 算法B 扩展穷举 k=13..20 (已知 A008407: 48,50,56,60,66,70,76,80)")
    P("=" * 88)
    known2 = {13: 48, 14: 50, 15: 56, 16: 60, 17: 66, 18: 70, 19: 76, 20: 80}
    for k in [13, 14, 15, 16, 17, 18, 19, 20]:
        t0 = time.time()
        h, w = hk_naive(k, budget_s=900)
        el = time.time() - t0
        if h is None:
            P(f"    k={k}: {w}")
        else:
            ok = (h == known2[k])
            P(f"    k={k}: H(k)={h} 已知={known2[k]}  {'PASS' if ok else 'FAIL'}  "
              f"(用时 {el:.1f}s, 见证前 20 项 {list(w)[:20]}...)")

    # ------------------------- 4. 算法C 边界抽查 -------------------------
    P("\n" + "=" * 88)
    P("[4] UNSAT 侧 (算法C 剩余类分配搜索): H(k) 边界局部抽查")
    P("    完备判定: 存在直径<=d 的可容许 k 元组 <=> 存在 (c_p) 使幸存位置数>=k")
    P("=" * 88)

    # 4a. 算法C 对 k=2..12 也跑一遍 H(k), 与算法B 对拍
    P("\n[4a] 算法C vs 算法B 对拍 (k=2..12):")
    cross_ok = True
    for k in range(2, 13):
        # 找最小 d 使 SAT(d) 为真
        t0 = time.time()
        found_d = None
        for d in range(0, 200, 2):
            ok, w, nodes = sat_le_d(k, d, budget_s=60)
            if ok is True:
                found_d = d
                break
            if ok is None:   # 超时
                break
        if found_d is None:
            cross_ok = False
            P(f"    k={k}: 算法C 超时/未完成")
            continue
        b = naive_results.get(k, (None, None))[0]
        agree = (b == found_d)
        if not agree:
            cross_ok = False
        P(f"    k={k}: 算法C H(k)={found_d}  算法B H(k)={b}  "
          f"{'一致 PASS' if agree else '不一致 FAIL'}")
    P(f"    算法C/算法B 交叉一致: {'PASS' if cross_ok else 'FAIL'}")

    # 4b. 奇偶 d 一致性抽查 (SAT(H-1) 应等于 SAT(H-2))
    P("\n[4b] 奇偶直径一致性抽查 (可容许元组直径必为偶数):")
    for k, h in [(12, 42), (20, 80), (30, 136)]:
        ok_odd, _, _ = sat_le_d(k, h - 1, budget_s=60)
        ok_even, _, _ = sat_le_d(k, h - 2, budget_s=60)
        P(f"    k={k}: SAT(d={h-1})={ok_odd}  SAT(d={h-2})={ok_even}  "
          f"{'一致 PASS' if ok_odd == ok_even else '不一致 FAIL'}")

    # 4c. 大 k 边界抽查
    P("\n[4c] 大 k 边界抽查 (期望: d=H(k)-2 为 UNSAT, d=H(k) 为 SAT):")
    spot = [(20, 78, 80), (30, 134, 136), (42, 194, 196), (46, 214, 216), (50, 244, 246)]
    spot_all_ok = True
    for k, d_lo, d_hi in spot:
        for label, d in [("UNSAT侧", d_lo), ("SAT侧", d_hi)]:
            t0 = time.time()
            ok, w, nodes = sat_le_d(k, d, budget_s=300)
            el = time.time() - t0
            if ok is None:
                P(f"    k={k} d={d} [{label}]: 超时 ({w})  [节点 {nodes}]")
                spot_all_ok = False
                continue
            expect = (label == "SAT侧")
            good = (ok == expect)
            if ok:
                # 抽出见证的独立复核: 必须可容许、长度 k、直径恰为 d
                a1, _ = is_admissible_set(k, w)
                a2, _ = is_admissible_freq(k, w)
                diam = max(w) - min(w)
                wok = a1 and a2 and len(w) == k and len(set(w)) == k and diam == d
                if not wok:
                    good = False
                msg = (f"SAT  (抽出见证 {list(w[:8])}... 共{len(w)}个, 直径{diam}, "
                       f"可容许复核 {'OK' if (a1 and a2) else 'FAIL'})")
            else:
                msg = "UNSAT"
            if not good:
                spot_all_ok = False
            P(f"    k={k} d={d} [{label}]: {msg}  期望{'SAT' if expect else 'UNSAT'}  "
              f"{'PASS' if good else 'FAIL'}  (节点 {nodes}, 用时 {el:.1f}s)")

    # ------------------------- 汇总 -------------------------
    P("\n" + "=" * 88)
    P("汇总")
    P("=" * 88)
    P(f"  SAT 侧见证验证:            {'全部 PASS' if all_ok else '存在 FAIL'}")
    P(f"  k=2..12 朴素穷举 H(k):     {'全部 PASS' if naive_ok else '存在 FAIL'}")
    P(f"  算法C 对拍 + 边界抽查:      {'全部 PASS' if (cross_ok and spot_all_ok) else '存在 FAIL'}")
    P(f"  总用时: {time.time() - t_start:.1f}s")
    log.close()

if __name__ == "__main__":
    main()
