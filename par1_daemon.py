#!/usr/bin/env python3
"""一级 (par) 守护进程 v5: 直接证明 H(k) 精确性的全部边界。

对每个 (k, H) 目标, 对每个偶数 d ∈ [dmin, H-2]:
  dmin = 鸽笼下界: poolsz=(d-2)/2 需 ≥ k-2 ⟺ d ≥ 2(k-1) → dmin = 2(k-1)
  运行 level-1 (i0 子空间) admissible_par k d i0, 结果 par_jobs/p{k}_{d}_i{i0}.txt
  超 25 分钟的任务拆分到 par2_tasks.txt (unified_daemon 接管深层拆分)

v5 优化: 预加载"已拆分"集合 (空文件 + par2 子任务存在 ⟹ 视为完成),
避免重复运行已拆分节点; 主循环无全文件扫描。
"""
import os, subprocess, sys, time

BASE = os.path.dirname(os.path.abspath(__file__))
os.chdir(BASE)

TARGETS = [(50, 246), (46, 216), (45, 212), (44, 210), (43, 200)]

TASKS = []
for k, H in TARGETS:
    dmin = 2 * (k - 1)
    for d in range(dmin, H - 1, 2):
        poolsz = (d - 2) // 2
        for i0 in range(poolsz):
            TASKS.append((k, d, i0))

QUOTA = 40
SPLIT_SECS = 1500

def resfile(k, d, i0):
    return os.path.join('par_jobs', f"p{k}_{d}_i{i0}.txt")

def load_split_set():
    """已拆分到 par2 的 (k,d,i0) 集合"""
    s = set()
    if os.path.exists('par2_tasks.txt'):
        with open('par2_tasks.txt') as f:
            for line in f:
                parts = line.split()
                if len(parts) >= 4:
                    s.add((int(parts[0]), int(parts[1]), int(parts[2])))
    return s

def done(k, d, i0, split_set=None):
    p = resfile(k, d, i0)
    if os.path.exists(p) and os.path.getsize(p) > 0:
        return True
    if split_set is not None and (k, d, i0) in split_set:
        return True
    return False

def main():
    running = {}  # pid -> (k, d, i0, start, Popen)
    split_set = load_split_set()
    last_reload = time.time()
    print(f"par1_daemon v5 started: {len(TASKS)} tasks", flush=True)
    while True:
        if time.time() - last_reload > 60:
            split_set = load_split_set()
            last_reload = time.time()
        # 收割已结束的
        for pid in list(running):
            k, d, i0, t0, pop = running[pid]
            if pop.poll() is not None:
                del running[pid]
        # 拆分超时任务
        for pid, (k, d, i0, t0, pop) in list(running.items()):
            if time.time() - t0 > SPLIT_SECS:
                try:
                    pop.kill()
                except Exception:
                    pass
                del running[pid]
                poolsz = (d - 2) // 2
                with open('par2_tasks.txt', 'a') as f:
                    for j0 in range(i0 + 1, poolsz):
                        f.write(f"{k} {d} {i0} {j0}\n")
                print(f"SPLIT1: {k} {d} {i0}", flush=True)
        # 启动新任务
        if len(running) < QUOTA:
            launched_now = 0
            for k, d, i0 in TASKS:
                if len(running) + launched_now >= QUOTA:
                    break
                if done(k, d, i0, split_set):
                    continue
                if any(rn[0] == k and rn[1] == d and rn[2] == i0 for rn in running.values()):
                    continue
                fn = resfile(k, d, i0)
                with open(fn, 'w'):
                    pass
                try:
                    pop = subprocess.Popen(['./admissible_par', str(k), str(d), str(i0)],
                                           stdout=open(fn, 'w'), stderr=subprocess.STDOUT)
                    running[pop.pid] = (k, d, i0, time.time(), pop)
                    launched_now += 1
                except Exception as e:
                    print(f"LAUNCH-FAIL {k} {d} {i0}: {e}", flush=True)
            if launched_now:
                print(f"[{time.strftime('%H:%M:%S')}] par1: +{launched_now} running={len(running)}", flush=True)
        todo_left = sum(1 for t in TASKS if not done(t[0], t[1], t[2], split_set))
        if todo_left == 0 and not running:
            print("par1: ALL DONE", flush=True)
            break
        time.sleep(1) if launched_now == 0 else time.sleep(0.2)
    print("par1: FINISHED", flush=True)

if __name__ == '__main__':
    main()
