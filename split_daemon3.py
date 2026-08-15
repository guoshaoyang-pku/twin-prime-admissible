#!/usr/bin/env python3
"""难任务拆分器 v3：处理 par3 和 par2rest 的难任务（>25 分钟）"""
import subprocess, os, time

def get_procs(name):
    out = subprocess.run(['pgrep', '-x', name], capture_output=True, text=True).stdout
    for pid in out.split():
        try:
            ps = subprocess.run(['ps', '-p', pid, '-o', 'pid=', '-o', 'etime=', '-o', 'args='],
                                capture_output=True, text=True).stdout.strip()
            parts = ps.split(None, 2)
            if len(parts) < 3:
                continue
            p, et, args = parts
            ets = et.split('-')
            if len(ets) == 2:
                days = int(ets[0]); t = ets[1]
            else:
                days = 0; t = ets[0]
            hms = t.split(':')
            secs = days*86400 + int(hms[0])*3600 + int(hms[1])*60 + int(hms[2])
            yield p, secs, args
        except Exception:
            pass

while True:
    try:
        # par3 难任务 → 四级
        for pid, secs, args in get_procs('admissible_par3'):
            if secs >= 1500:
                a = args.split()
                if len(a) >= 6 and a[0] == './admissible_par3':
                    k, d, i0, j0, k0 = a[1], a[2], a[3], a[4], a[5]
                    mark = f"par4_tasks_done/m_{k}_{d}_{i0}_{j0}_{k0}"
                    if not os.path.exists(mark):
                        open(mark, 'w').close()
                        try: os.kill(int(pid), 9)
                        except Exception: pass
                        sz = (int(d) - 4) // 2
                        with open('par4_tasks.txt', 'a') as f:
                            for k1 in range(int(k0)+1, sz+1):
                                f.write(f"{k} {d} {i0} {j0} {k0} {k1}\n")
                        with open('par4_split_log.txt', 'a') as f:
                            f.write(f"SPLIT3: {k} {d} {i0} {j0} {k0}\n")
        # par4 难任务 → 五级 (k2 拆分)
        for pid, secs, args in get_procs('admissible_par4'):
            if secs >= 1500:
                a = args.split()
                if len(a) >= 7 and a[0] == './admissible_par4':
                    k, d, i0, j0, k0, k1 = a[1], a[2], a[3], a[4], a[5], a[6]
                    mark = f"par5_tasks_done/m_{k}_{d}_{i0}_{j0}_{k0}_{k1}"
                    try: os.kill(int(pid), 9)
                    except Exception: pass
                    if not os.path.exists(mark):
                        open(mark, 'w').close()
                        sz = (int(d) - 4) // 2
                        with open('par5_tasks.txt', 'a') as f:
                            for k2 in range(int(k1)+1, sz+1):
                                f.write(f"{k} {d} {i0} {j0} {k0} {k1} {k2}\n")
                        with open('par4_split_log.txt', 'a') as f:
                            f.write(f"SPLIT5: {k} {d} {i0} {j0} {k0} {k1}\n")
        # par2rest 难任务 → 三级（i0>=1 部分）
        for pid, secs, args in get_procs('admissible_par2'):
            if secs >= 1500:
                a = args.split()
                if len(a) >= 5 and a[0] == './admissible_par2':
                    k, d, i0, j0 = a[1], a[2], a[3], a[4]
                    if int(i0) >= 1:  # 只处理 par2rest 的（i0>=1）
                        mark = f"par2rest_par3_done/m_{k}_{d}_{i0}_{j0}"
                        try: os.kill(int(pid), 9)
                        except Exception: pass
                        if not os.path.exists(mark):
                            open(mark, 'w').close()
                            sz = (int(d) - 4) // 2
                            with open('par2rest_par3_tasks.txt', 'a') as f:
                                for k0 in range(int(j0)+1, sz+1):
                                    f.write(f"{k} {d} {i0} {j0} {k0}\n")
                            with open('par4_split_log.txt', 'a') as f:
                                f.write(f"SPLIT2: {k} {d} {i0} {j0}\n")
    except Exception as e:
        with open('par4_split_log.txt', 'a') as f:
            f.write(f"ERR: {e}\n")
    time.sleep(45)
