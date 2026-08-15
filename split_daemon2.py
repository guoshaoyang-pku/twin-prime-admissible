#!/usr/bin/env python3
"""难任务拆分器 v2：pgrep -x 精确匹配，>25 分钟拆分为四级"""
import subprocess, os, time

def get_par3():
    out = subprocess.run(['pgrep', '-x', 'admissible_par3'], capture_output=True, text=True).stdout
    for pid in out.split():
        try:
            ps = subprocess.run(['ps', '-p', pid, '-o', 'pid=', '-o', 'etime=', '-o', 'args='],
                                capture_output=True, text=True).stdout.strip()
            parts = ps.split(None, 2)
            if len(parts) < 3:
                continue
            p, et, args = parts
            # etime 格式: [[DD-]HH:]MM:SS
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
        for pid, secs, args in get_par3():
            if secs >= 1500:  # 25 分钟
                a = args.split()
                if len(a) >= 6 and a[0] == './admissible_par3':
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
    time.sleep(45)
