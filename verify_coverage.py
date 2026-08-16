#!/usr/bin/env python3
"""验证 (k,d) 的完备子空间划分覆盖 (v3: 区分 pending / gap)。

划分树 (pool = 偶数 2,4,...,d-2, 索引 0..poolsz-1, poolsz=(d-2)/2):
  level1: i0 ∈ [0, poolsz-1]                    结果: par_jobs/p{k}_d{d}_i{i0}.txt
  level2: (i0,j0) j0>i0                         结果: par2_results / par2rest_results
  level3: (i0,j0,k0) k0>j0                      结果: par3_results / par2rest_par3_results
  level4: (i0,j0,k0,k1) k1>k0                   结果: par4_results
任务列表: par2_tasks, par2rest_tasks, par3_tasks, par2rest_par3_tasks, par4_tasks

语义:
- 节点 (i0..im) 深度 m, 还需 t = K-2-m 个元素; 若 poolsz-1-im < t → 平凡 UNSAT。
- 若节点是任务文件的叶 (无更深任务扩展它) → 必须有非空 UNSAT 结果。
- 若节点被拆分 (有更深任务扩展) → 所有子节点必须覆盖。
- 非任务节点: 必须被结果覆盖, 或平凡, 或其祖先是已覆盖的叶。
"""
import os, sys, re
from collections import defaultdict, Counter

BASE = os.path.dirname(os.path.abspath(__file__))

def load_tasks(path):
    s = set()
    if os.path.exists(path):
        with open(path) as f:
            for line in f:
                parts = line.split()
                if parts:
                    s.add(tuple(map(int, parts)))
    return s

def result_status(dirs, name):
    for d in dirs:
        p = os.path.join(BASE, d, name)
        if os.path.exists(p):
            try:
                sz = os.path.getsize(p)
            except OSError:
                sz = 0
            if sz == 0:
                return ('EMPTY', p)
            with open(p, errors='replace') as f:
                content = f.read()
            if 'SAT witness' in content:
                return ('SAT', p)
            if 'UNSAT' in content:
                return ('UNSAT', p)
            if 'ERROR' in content:
                return ('ERROR', p)
            return ('UNKNOWN', p)
    return ('MISSING', None)

class Verifier:
    def __init__(self):
        self.tasks2 = load_tasks('par2_tasks.txt') | load_tasks('par2rest_tasks.txt')
        self.tasks3 = load_tasks('par3_tasks.txt') | load_tasks('par2rest_par3_tasks.txt')
        self.tasks4 = load_tasks('par4_tasks.txt')
        self.tasks5 = load_tasks('par5_tasks.txt')
        self.tasks6 = load_tasks('par6_tasks.txt')
        # 前缀索引: key = (k,d,i0,...)
        self.prefix2 = defaultdict(set)
        self.prefix3 = defaultdict(set)
        self.prefix4 = defaultdict(set)
        self.prefix5 = defaultdict(set)
        self.prefix6 = defaultdict(set)
        for t in self.tasks2:
            self.prefix2[t[:3]].add(t)
        for t in self.tasks3:
            self.prefix3[t[:4]].add(t)
        for t in self.tasks4:
            self.prefix4[t[:5]].add(t)
        for t in self.tasks5:
            self.prefix5[t[:6]].add(t)
        for t in self.tasks6:
            self.prefix6[t[:7]].add(t)
        self.tasks1 = load_tasks('par1_tasks.txt')
        self.counterexamples = []
        self.gaps = []
        self.pending = []
        self.nodes_checked = 0
        self.memo = {}

    def level1_name(self, k, d, i0):
        return f"p{k}_{d}_i{i0}.txt"

    def result_name(self, k, d, idx):
        return "r_" + "_".join(str(x) for x in ([k, d] + list(idx))) + ".txt"

    def dirs_for(self, m):
        if m == 1:
            return ['par_jobs']
        if m == 2:
            return ['par2_results', 'par2rest_results']
        if m == 3:
            return ['par3_results', 'par2rest_par3_results']
        if m == 4:
            return ['par4_results']
        if m == 5:
            return ['par5_results']
        return ['par6_results']

    def children_tasks(self, node, k, d):
        """任务文件中以 node 为前缀的下一级任务"""
        if len(node) == 1:
            pool = self.prefix2[(k, d) + node]
        elif len(node) == 2:
            pool = self.prefix3[(k, d) + node]
        elif len(node) == 3:
            pool = self.prefix4[(k, d) + node]
        elif len(node) == 4:
            pool = self.prefix5[(k, d) + node]
        else:
            pool = self.prefix6[(k, d) + node]
        return {t for t in pool if len(t) == len(node) + 3}

    def check_leaf(self, k, d, poolsz, node, is_task):
        """检查一个叶节点。返回 True=覆盖。"""
        m = len(node)
        t = k - 2 - m
        last = node[-1]
        if poolsz - 1 - last < t:
            return True
        dirs = self.dirs_for(m)
        if m == 1:
            name = self.level1_name(k, d, node[0])
        else:
            name = self.result_name(k, d, node)
        status, path = result_status(dirs, name)
        if status == 'UNSAT':
            return True
        if status == 'SAT':
            self.counterexamples.append((k, d, node, path))
            return False
        if status == 'EMPTY':
            self.pending.append((k, d, node, 'EMPTY-RESULT'))
            return False
        if status == 'MISSING':
            if is_task:
                self.pending.append((k, d, node, 'MISSING-RESULT-BUT-TASK'))
            else:
                self.gaps.append((k, d, node, 'MISSING-RESULT-NOT-TASK', None))
            return False
        self.gaps.append((k, d, node, status, path))
        return False

    def cover(self, k, d, poolsz, node):
        key = (k, d, node)
        if key in self.memo:
            return self.memo[key]
        self.nodes_checked += 1
        m = len(node)
        t = k - 2 - m
        last = node[-1]
        if poolsz - 1 - last < t:
            self.memo[key] = True
            return True
        # 节点自身已有结果则直接覆盖 (无需深入子任务)
        dirs_self = self.dirs_for(m)
        if m == 1:
            name_self = self.level1_name(k, d, node[0])
        else:
            name_self = self.result_name(k, d, node)
        st_self, _ = result_status(dirs_self, name_self)
        if st_self == 'UNSAT':
            self.memo[key] = True
            return True
        kids = self.children_tasks(node, k, d)
        if kids:
            ok = True
            for kid in kids:
                if not self.cover(k, d, poolsz, kid[2:]):
                    ok = False
            # 完整性: 每个 x ∈ [last+1, poolsz-1] 必须被子任务覆盖或自身有结果
            kid_set = {kid[-1] for kid in kids}
            for x in range(last + 1, poolsz):
                if x in kid_set:
                    continue
                child = node + (x,)
                if poolsz - 1 - x < k - 2 - (len(node) + 1):
                    continue  # 平凡 UNSAT
                # 该子节点必须已有结果
                dirs = self.dirs_for(len(node) + 1)
                if len(node) + 1 == 1:
                    name = self.level1_name(k, d, child[0])
                else:
                    name = self.result_name(k, d, child)
                st, _ = result_status(dirs, name)
                if st != 'UNSAT':
                    self.gaps.append((k, d, child, f'UNCOVERED-x={x}', None))
                    ok = False
            if not ok:
                self.gaps.append((k, d, node, 'CHILDREN-GAP', None))
            self.memo[key] = ok
            return ok
        is_task = self.is_task(node, k, d)
        ok = self.check_leaf(k, d, poolsz, node, is_task)
        self.memo[key] = ok
        return ok

    def is_task(self, node, k, d):
        """节点是否出现在某个任务文件中 (作为条目或前缀)"""
        if len(node) == 1:
            return (k, d) + node in self.tasks1
        if len(node) == 2:
            return (k, d) + node in self.tasks2
        if len(node) == 3:
            return (k, d) + node in self.tasks3
        if len(node) == 4:
            return (k, d) + node in self.tasks4
        if len(node) == 5:
            return (k, d) + node in self.tasks5
        return (k, d) + node in self.tasks6

    def verify(self, k, d):
        poolsz = (d - 2) // 2
        bad = []
        for i0 in range(poolsz):
            if not self.cover(k, d, poolsz, (i0,)):
                bad.append(i0)
        return bad

# H(k) 精确性目标: 需要 k 在 [dmin, H-2] 所有偶数 d 的 UNSAT (dmin=2(k-1) 鸽笼平凡)
TARGETS = []
for k, H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for d in range(2 * (k - 1), H - 1, 2):
        TARGETS.append((k, d))

def main():
    v = Verifier()
    total_ok = True
    for k, d in TARGETS:
        bad = v.verify(k, d)
        status = 'OK' if not bad else f'FAIL i0∈{bad[:15]}...'
        if bad:
            total_ok = False
        print(f"k={k} d={d}: {status}")
    print(f"\n检查节点数: {v.nodes_checked}")
    print(f"反例 (SAT witness): {len(v.counterexamples)}")
    for ce in v.counterexamples[:10]:
        print("  反例:", ce)
    print(f"缺口: {len(v.gaps)}")
    for g in v.gaps[:30]:
        print("  缺口:", g)
    print(f"待处理 (EMPTY/MISSING 但属于任务): {len(v.pending)}")
    pc = Counter((p[0], p[1], p[3]) for p in v.pending)
    for key, c in sorted(pc.items()):
        print(f"  pending {key}: {c}")
    sys.exit(0 if total_ok and not v.counterexamples and not v.gaps else 1)

if __name__ == '__main__':
    main()
