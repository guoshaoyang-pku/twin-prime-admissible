#!/usr/bin/env python3
"""priority_runner.py — 高优先级运行"目标 (k,d)"的待办叶子任务。
绕过 unified daemon 的随机化 (5万任务中少数目标被饿死)。
处理 par3/par4/par5/par6 四级, 优先运行验证目标覆盖所需的任务。
"""
import os, subprocess, sys, time

BASE = os.path.dirname(os.path.abspath(__file__))
os.chdir(BASE)

TARGETS = []
for k, H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for d in range(2 * (k - 1), H - 1, 2):
        TARGETS.append((k, d))
TSET = set(TARGETS)

QUOTA = 25  # 高优先级进程配额 (与 unified 共享机器)

def load_tasks(path):
    s = set()
    if os.path.exists(path):
        with open(path) as f:
            for line in f:
                parts = line.split()
                if parts:
                    s.add(tuple(map(int, parts)))
    return s

def has_result(node, dirs):
    for d in dirs:
        p = os.path.join(d, "r_" + "_".join(str(x) for x in node) + ".txt")
        if os.path.exists(p) and os.path.getsize(p) > 0:
            return True
    return False

def main():
    t3 = load_tasks('par3_tasks.txt') | load_tasks('par2rest_par3_tasks.txt')
    t4 = load_tasks('par4_tasks.txt')
    t5 = load_tasks('par5_tasks.txt')
    t6 = load_tasks('par6_tasks.txt')
    running = {}  # pid -> (prog, node)
    print(f"priority_runner started: {len(TARGETS)} targets", flush=True)
    while True:
        # 收割
        for pid in list(running):
            prog, node, pop = running[pid]
            if pop.poll() is not None:
                del running[pid]
        # 重新加载任务 (拆分会新增)
        t3 = load_tasks('par3_tasks.txt') | load_tasks('par2rest_par3_tasks.txt')
        t4 = load_tasks('par4_tasks.txt')
        t5 = load_tasks('par5_tasks.txt')
        t6 = load_tasks('par6_tasks.txt')
        # 找目标待办叶子 (从 par2 开始逐层下钻)
        todo2 = []
        for t in t3:
            if (t[0], t[1]) in TSET and not has_result(t, ['par3_results', 'par2rest_par3_results']):
                todo2.append(('admissible_par3', ['par3_results', 'par2rest_par3_results'], t))
        for t in t4:
            if (t[0], t[1]) in TSET and not has_result(t, ['par4_results']):
                todo2.append(('admissible_par4', ['par4_results'], t))
        for t in t5:
            if (t[0], t[1]) in TSET and not has_result(t, ['par5_results']):
                todo2.append(('admissible_par5', ['par5_results'], t))
        for t in t6:
            if (t[0], t[1]) in TSET and not has_result(t, ['par6_results']):
                todo2.append(('admissible_par6', ['par6_results'], t))
        running_full = set()
        for pid, (prog, task, pop) in running.items():
            running_full.add((prog, task))
        launched = 0
        for prog, dirs, task in todo2:
            if len(running) + launched >= QUOTA:
                break
            if (prog, task) in running_full:
                continue
            fn = os.path.join(dirs[0], "r_" + "_".join(str(x) for x in task) + ".txt")
            with open(fn, 'w'):
                pass
            try:
                pop = subprocess.Popen(['./' + prog] + [str(x) for x in task],
                                       stdout=open(fn, 'w'), stderr=subprocess.STDOUT)
                running[pop.pid] = (prog, task, pop)
                launched += 1
            except Exception as e:
                print(f"LAUNCH-FAIL {task}: {e}", flush=True)
        if launched:
            print(f"[{time.strftime('%H:%M:%S')}] priority: +{launched} running={len(running)}", flush=True)
        time.sleep(5)

if __name__ == '__main__':
    main()
