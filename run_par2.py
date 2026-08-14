"""自动排队运行二级子空间任务，结果写入 par2_results/"""
import subprocess, os, sys, time
from concurrent.futures import ProcessPoolExecutor

os.makedirs('par2_results', exist_ok=True)
tasks = []
with open('par2_tasks.txt') as fh:
    for line in fh:
        tasks.append(tuple(map(int, line.split())))

done = set()
for fn in os.listdir('par2_results'):
    if fn.endswith('.txt'):
        done.add(fn)

def run_one(t):
    k, d, i0, j0 = t
    fn = f"par2_results/r_{k}_{d}_{i0}_{j0}.txt"
    try:
        r = subprocess.run(['./admissible_par2', str(k), str(d), str(i0), str(j0)],
                           capture_output=True, text=True, timeout=7200)
        with open(fn, 'w') as f:
            f.write(r.stdout)
    except Exception as e:
        with open(fn, 'w') as f:
            f.write(f"ERROR: {e}\n")
    return fn

pending = [t for t in tasks if f"r_{t[0]}_{t[1]}_{t[2]}_{t[3]}.txt" not in done]
print(f"待处理: {len(pending)} / {len(tasks)}", flush=True)
with ProcessPoolExecutor(max_workers=190) as ex:
    for i, fn in enumerate(ex.map(run_one, pending)):
        if (i+1) % 500 == 0:
            print(f"完成 {i+1}/{len(pending)}", flush=True)
print("全部完成", flush=True)
