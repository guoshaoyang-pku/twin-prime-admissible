#!/usr/bin/env python3
"""par5_splitter.py v2 — 拆分 par4 长任务 (>25min) 到 par5, par5 长任务到 par6。
用 /proc 直接读进程 (不依赖 ps 命令), 避免卡死。"""
import os, time, glob

def get_procs(binary):
    """从 /proc 读取进程: {pid: (args_list, age_secs)}"""
    result = {}
    now = time.time()
    for pid_dir in glob.glob('/proc/[0-9]*'):
        pid = pid_dir.split('/')[-1]
        try:
            with open(f'/proc/{pid}/cmdline', 'rb') as f:
                raw = f.read().split(b'\x00')
            args = [x.decode(errors='replace') for x in raw if x]
            if not args or binary not in args[0]:
                continue
            with open(f'/proc/{pid}/stat', 'rb') as f:
                stat_data = f.read().decode(errors='replace')
            idx = stat_data.rfind(')')
            fields = stat_data[idx+1:].split()
            starttime_ticks = int(fields[19])
            with open('/proc/stat') as f:
                for line in f:
                    if line.startswith('btime '):
                        btime = int(line.split()[1])
                        break
            hz = 100
            try:
                hz = os.sysconf('SC_CLK_TCK')
            except (ValueError, AttributeError):
                pass
            start = btime + starttime_ticks / hz
            result[pid] = (args, now - start)
        except Exception:
            continue
    return result

def main():
    print("par5_splitter v3 started", flush=True)
    while True:
        try:
            # par2 → par3 (所有 i0, >25min)
            for pid, (args, age) in get_procs('admissible_par2').items():
                if age >= 1500:
                    a = args
                    if len(a) >= 5:
                        k, d, i0, j0 = a[1], a[2], a[3], a[4]
                        mark = f"par2rest_par3_done/m_{k}_{d}_{i0}_{j0}"
                        try:
                            os.kill(int(pid), 9)
                        except Exception:
                            pass
                        if not os.path.exists(mark):
                            open(mark, 'w').close()
                            sz = (int(d) - 4) // 2
                            with open('par2rest_par3_tasks.txt', 'a') as f:
                                for k0 in range(int(j0) + 1, sz + 1):
                                    f.write(f"{k} {d} {i0} {j0} {k0}\n")
                            with open('par4_split_log.txt', 'a') as f:
                                f.write(f"SPLIT2: {k} {d} {i0} {j0}\n")
                            print(f"SPLIT2: {k} {d} {i0} {j0}", flush=True)
            # par3 → par4 (所有 i0, >25min)
            for pid, (args, age) in get_procs('admissible_par3').items():
                if age >= 1500:
                    a = args
                    if len(a) >= 6:
                        k, d, i0, j0, k0 = a[1], a[2], a[3], a[4], a[5]
                        mark = f"par4_tasks_done/m_{k}_{d}_{i0}_{j0}_{k0}"
                        try:
                            os.kill(int(pid), 9)
                        except Exception:
                            pass
                        if not os.path.exists(mark):
                            open(mark, 'w').close()
                            sz = (int(d) - 4) // 2
                            with open('par4_tasks.txt', 'a') as f:
                                for k1 in range(int(k0) + 1, sz + 1):
                                    f.write(f"{k} {d} {i0} {j0} {k0} {k1}\n")
                            with open('par4_split_log.txt', 'a') as f:
                                f.write(f"SPLIT3: {k} {d} {i0} {j0} {k0}\n")
                            print(f"SPLIT3: {k} {d} {i0} {j0} {k0}", flush=True)
            # par4 → par5
            for pid, (args, age) in get_procs('admissible_par4').items():
                if age >= 1500:
                    a = args
                    if len(a) >= 7:
                        k, d, i0, j0, k0, k1 = a[1], a[2], a[3], a[4], a[5], a[6]
                        mark = f"par5_tasks_done/m_{k}_{d}_{i0}_{j0}_{k0}_{k1}"
                        try:
                            os.kill(int(pid), 9)
                        except Exception:
                            pass
                        if not os.path.exists(mark):
                            open(mark, 'w').close()
                            sz = (int(d) - 4) // 2
                            with open('par5_tasks.txt', 'a') as f:
                                for k2 in range(int(k1) + 1, sz + 1):
                                    f.write(f"{k} {d} {i0} {j0} {k0} {k1} {k2}\n")
                            with open('par4_split_log.txt', 'a') as f:
                                f.write(f"SPLIT5: {k} {d} {i0} {j0} {k0} {k1}\n")
                            print(f"SPLIT5: {k} {d} {i0} {j0} {k0} {k1}", flush=True)
            # par5 → par6
            for pid, (args, age) in get_procs('admissible_par5').items():
                if age >= 1500:
                    a = args
                    if len(a) >= 8:
                        k, d, i0, j0, k0, k1, k2 = a[1], a[2], a[3], a[4], a[5], a[6], a[7]
                        mark = f"par6_tasks_done/m_{k}_{d}_{i0}_{j0}_{k0}_{k1}_{k2}"
                        try:
                            os.kill(int(pid), 9)
                        except Exception:
                            pass
                        if not os.path.exists(mark):
                            open(mark, 'w').close()
                            sz = (int(d) - 4) // 2
                            with open('par6_tasks.txt', 'a') as f:
                                for k3 in range(int(k2) + 1, sz + 1):
                                    f.write(f"{k} {d} {i0} {j0} {k0} {k1} {k2} {k3}\n")
                            with open('par4_split_log.txt', 'a') as f:
                                f.write(f"SPLIT6: {k} {d} {i0} {j0} {k0} {k1} {k2}\n")
                            print(f"SPLIT6: {k} {d} {i0} {j0} {k0} {k1} {k2}", flush=True)
        except Exception as e:
            print(f"ERR: {e}", flush=True)
        time.sleep(30)

if __name__ == '__main__':
    main()
