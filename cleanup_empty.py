#!/usr/bin/env python3
"""清理卡死的空结果文件: 删除"无子任务且无运行进程"的空结果文件,
让守护进程重新运行它们。有子任务的空文件保留 (由子任务覆盖)。"""
import os, subprocess, sys

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

tasks2 = load_tasks('par2_tasks.txt') | load_tasks('par2rest_tasks.txt')
tasks3 = load_tasks('par3_tasks.txt') | load_tasks('par2rest_par3_tasks.txt')
tasks4 = load_tasks('par4_tasks.txt')

def running_procs():
    out = subprocess.run(['ps', '-eo', 'pid,args'], capture_output=True, text=True).stdout
    procs = []
    for line in out.splitlines():
        line = line.strip()
        if 'admissible_par' in line and 'grep' not in line:
            parts = line.split(None, 1)
            if len(parts) == 2:
                procs.append((parts[0], parts[1]))
    return procs

def main():
    procs = running_procs()
    # 运行中的任务集合: (程序, k, d, i0, [j0, [k0, [k1]]])
    running = set()
    for pid, args in procs:
        a = args.split()
        if a and a[0].startswith('./admissible_par'):
            prog = a[0]
            nums = tuple(int(x) for x in a[1:])
            running.add((prog, nums))

    dirs = [
        ('par2_results', 4), ('par2rest_results', 4),
        ('par3_results', 5), ('par2rest_par3_results', 5),
        ('par4_results', 6),
    ]
    deleted = []
    kept_split = 0
    for d, nfields in dirs:
        if not os.path.isdir(d):
            continue
        for fn in os.listdir(d):
            if not fn.endswith('.txt'):
                continue
            p = os.path.join(d, fn)
            if os.path.getsize(p) != 0:
                continue
            # 解析任务
            parts = fn[:-4].split('_')[1:]
            try:
                nums = tuple(int(x) for x in parts)
            except ValueError:
                continue
            if len(nums) != nfields - 2 + 2:
                # 文件名格式 r_k_d_i0[_j0[_k0[_k1]]].txt → nums = (k,d,i0,...)
                pass
            k, dnum = nums[0], nums[1]
            node = nums[2:]
            # 该空文件对应哪个可执行程序?
            if len(node) == 2:
                prog = './admissible_par2'
                tasks = tasks2
            elif len(node) == 3:
                prog = './admissible_par3'
                tasks = tasks3
            else:
                prog = './admissible_par4'
                tasks = tasks4
            # 有子任务? (更深级别任务以该节点为前缀)
            if len(node) == 2:
                children = {t for t in tasks3 if t[:4] == (k, dnum) + node}
            elif len(node) == 3:
                children = {t for t in tasks4 if t[:5] == (k, dnum) + node}
            else:
                children = set()
            # 正在运行?
            is_running = (prog, nums) in running or any(
                r[0] == prog and r[1][:len(nums)] == nums for r in running)
            if children:
                kept_split += 1
                continue  # 保留: 子任务覆盖
            if is_running:
                continue  # 保留: 正在运行
            os.remove(p)
            deleted.append((d, fn))
            # 同时删除陈旧的锁文件
            for lockdir in ('par3_locks', 'par2rest_locks', 'par2rest_par3_locks'):
                lf = os.path.join(lockdir, 'l_' + '_'.join(str(x) for x in nums))
                if os.path.exists(lf):
                    os.remove(lf)
    print(f"删除空文件: {len(deleted)}")
    for d, fn in deleted[:50]:
        print(f"  {d}/{fn}")
    print(f"保留(有子任务): {kept_split}")

if __name__ == '__main__':
    main()
