#!/usr/bin/env python3
"""统一守护进程 v2: 管理 par2/par2rest/par3/par2rest_par3/par4 任务队列。

特性:
- 内存内去重: 同一任务绝不同时运行两份 (无锁文件竞态)。
- 随机化扫描: 每轮从任务文件中随机取样, 避免"文件头部任务饿死尾部任务"。
- 按可执行程序分配额: admissible_par2:90, admissible_par3:90, admissible_par4:30。
- 跳过: 结果非空 (已完成); 或该任务已被拆分 (有更深子任务)。
- 被拆分任务 (结果空 + 有子任务) 不再运行, 由子任务覆盖。
"""
import os, subprocess, sys, time, random

BASE = os.path.dirname(os.path.abspath(__file__))
os.chdir(BASE)

TARGETS = []
for _k, _H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        TARGETS.append((_k, _d))
TARGET_SET = set(TARGETS)

def load_tasks(path):
    s = set()
    if os.path.exists(path):
        with open(path) as f:
            for line in f:
                parts = line.split()
                if parts:
                    s.add(tuple(map(int, parts)))
    return s

# 合并队列: (名称, 任务文件列表, 程序, 结果目录列表, 配额)
QUEUES = [
    ('par2',  ['par2_tasks.txt', 'par2rest_tasks.txt'],
              'admissible_par2', ['par2_results', 'par2rest_results'], 0),
    ('par3',  ['par3_tasks.txt', 'par2rest_par3_tasks.txt'],
              'admissible_par3', ['par3_results', 'par2rest_par3_results'], 5),
    ('par4',  ['par4_tasks.txt'],
              'admissible_par4', ['par4_results'], 5),
    ('par5',  ['par5_tasks.txt'],
              'admissible_par5', ['par5_results'], 115),
    ('par6',  ['par6_tasks.txt'],
              'admissible_par6', ['par6_results'], 60),
]

def resfile(dirs, node):
    return os.path.join(dirs[0], "r_" + "_".join(str(x) for x in node) + ".txt")

def has_result(node, dirs):
    for d in dirs:
        p = os.path.join(BASE, d, "r_" + "_".join(str(x) for x in node) + ".txt")
        if os.path.exists(p) and os.path.getsize(p) > 0:
            return True
    return False

class UnifiedDaemon:
    def __init__(self):
        self._last_reload = 0
        self.tasks3 = load_tasks('par3_tasks.txt') | load_tasks('par2rest_par3_tasks.txt')
        self.tasks4 = load_tasks('par4_tasks.txt')
        self.tasks5 = load_tasks('par5_tasks.txt')
        self.tasks6 = load_tasks('par6_tasks.txt')
        self.running = {}  # pid -> (node, prog)
        self.running_set = set()
        self.queues = []
        for name, paths, prog, dirs, quota in QUEUES:
            tasks = set()
            for path in paths:
                tasks |= load_tasks(path)
            self.queues.append({
                'name': name, 'prog': prog, 'dirs': dirs, 'quota': quota,
                'tasks': tasks, '_paths': paths, 'sorted': None, 'cursor': 0,
            })

    def has_children(self, node):
        """该任务是否被拆分 (有更深子任务). node 是含 k,d 的完整任务元组."""
        if len(node) == 4:
            return any(t[:4] == node for t in self.tasks3)
        if len(node) == 5:
            return any(t[:5] == node for t in self.tasks4)
        if len(node) == 6:
            return any(t[:6] == node for t in self.tasks5)
        if len(node) == 7:
            return any(t[:7] == node for t in self.tasks6)
        return False

    def count_running(self, prog):
        return sum(1 for p, (n, pr, pop) in self.running.items() if pr == prog)

    def _sync_running_set(self):
        self.running_set = set()
        for p, (n, pr, pop) in self.running.items():
            self.running_set.add((pr, n))

    def sweep(self):
        """清理已结束的进程 (用 Popen.poll 收割)"""
        for pid in list(self.running):
            node, prog, pop = self.running[pid]
            if pop.poll() is not None:
                del self.running[pid]
                self.running_set.discard((prog, node))
                # 完成后标记 done (结果已写入)
                for q in self.queues:
                    if q['prog'] == prog and 'done_set' in q:
                        q['done_set'].add("r_" + "_".join(str(x) for x in node))

    def launch(self, node, prog, dirs):
        args = ['./' + prog] + [str(x) for x in node]
        try:
            os.makedirs(dirs[0], exist_ok=True)
            fn = resfile(dirs, node)
            with open(fn, 'w'):
                pass
            # 新启动的任务: 从 done_set 移除 (空文件不算完成)
            for q in self.queues:
                if q['prog'] == prog and 'done_set' in q:
                    q['done_set'].discard("r_" + "_".join(str(x) for x in node))
            p = subprocess.Popen(args, stdout=open(fn, 'w'), stderr=subprocess.STDOUT)
            self.running[p.pid] = (node, prog, p)
            self.running_set.add((prog, node))
            return True
        except Exception as e:
            print(f"LAUNCH-FAIL {node}: {e}", flush=True)
            return False

    def reload_tasks(self):
        """重新加载任务文件 (split_daemon 会追加新任务)"""
        for q in self.queues:
            tasks = set()
            for path in q['_paths']:
                tasks |= load_tasks(path)
            q['tasks'] = tasks
            # 预排序: 目标任务优先 (只排一次, 避免每 tick 全量排序)
            q['sorted'] = sorted(tasks, key=lambda t: ((t[0], t[1]) not in TARGET_SET, -t[1] if (t[0], t[1]) in TARGET_SET else 0, hash(t)))
            # 预扫描结果文件名集合 (避免每 tick 逐个 stat)
            q['done_set'] = set()
            for dr in q['dirs']:
                if os.path.isdir(dr):
                    for fn in os.listdir(dr):
                        fp = os.path.join(dr, fn)
                        try:
                            if os.path.getsize(fp) > 0:
                                q['done_set'].add(fn[:-4])
                        except OSError:
                            pass

    def tick(self):
        self.sweep()
        now = time.time()
        if now - self._last_reload > 300:
            self.reload_tasks()
            self._last_reload = now
        for q in self.queues:
            prog = q['prog']
            quota = q['quota']
            tasks = q.get('sorted') or list(q['tasks'])
            n = len(tasks)
            launched = 0
            self._sync_running_set()
            for node in tasks:
                if self.count_running(prog) + launched >= quota:
                    break
                fn_key = "r_" + "_".join(str(x) for x in node)
                if fn_key in q['done_set']:
                    continue
                if self.has_children(node):
                    continue  # 已拆分, 由子任务覆盖
                if (prog, node) in self.running_set:
                    continue
                if self.launch(node, prog, q['dirs']):
                    launched += 1
            if launched:
                print(f"[{time.strftime('%H:%M:%S')}] {q['name']}: +{launched} (running={self.count_running(prog)})", flush=True)

    def run(self):
        print("UnifiedDaemon started", flush=True)
        while True:
            try:
                self.tick()
            except Exception as e:
                print(f"TICK-ERR: {e}", flush=True)
            time.sleep(1)

if __name__ == '__main__':
    UnifiedDaemon().run()
