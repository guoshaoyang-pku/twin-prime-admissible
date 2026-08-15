#!/usr/bin/env python3
"""难任务拆分器：每 60 秒检查 admissible_par3 进程，>25 分钟 CPU 的拆分为四级"""
import subprocess, os, time

def get_par3_procs():
    out = subprocess.run(['ps', 'aux'], capture_output=True, text=True).stdout
    procs = []
    for line in out.splitlines():
        if 'admissible_par3 ' in line:
            parts = line.split()
            if len(parts) > 13:
                pid = parts[1]
                # TIME 字段是第 10 列
                cput = parts[9]
                if ':' in cput:
                    if cput.count(':') == 2:
                        h, m, s = cput.split(':')
                        mins = int(h)*60 + int(m)
                    else:
                        m, s = cput.split(':')
                        mins = int(m)
                else:
                    mins = int(cput) // 60
                args = ' '.join(parts[10:])
                procs.append((pid, mins, args))
    return procs

while True:
    try:
        for pid, mins, args in get_par3_procs():
            if mins >= 25:
                a = args.split()
                if len(a) >= 7 and a[0] == './admissible_par3':
                    k, d, i0, j0, k0 = a[1], a[2], a[3], a[4], a[5]
                    mark = f"par4_tasks_done/m_{k}_{d}_{i0}_{j0}_{k0}"
                    if not os.path.exists(mark):
                        open(mark, 'w').close()
                        try:
                            os.kill(int(pid), 9)
                        except Exception:
                            pass
                        sz = (int(d) - 4) // 2
                        with open('par4_tasks.txt', 'a') as f:
                            for k1 in range(int(k0)+1, sz+1):
                                f.write(f"{k} {d} {i0} {j0} {k0} {k1}\n")
                        with open('par4_split_log.txt', 'a') as f:
                            f.write(f"SPLIT: {k} {d} {i0} {j0} {k0}\n")
    except Exception as e:
        with open('par4_split_log.txt', 'a') as f:
            f.write(f"ERR: {e}\n")
    time.sleep(60)
