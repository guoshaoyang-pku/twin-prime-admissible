#!/bin/bash
# 进度监控
cd /data3/guoshaoyang/workdir/math
echo "=== $(date '+%H:%M:%S') ==="
echo "进程: par=$(pgrep -xc admissible_par||echo 0) par2=$(pgrep -xc admissible_par2||echo 0) par3=$(pgrep -xc admissible_par3||echo 0) par4=$(pgrep -xc admissible_par4||echo 0)"
python3 - <<'EOF'
import os
TARGETS = [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]
for k, H in TARGETS:
    dmin = 2 * (k - 1)
    total_d = (H - dmin) // 2
    done_d = 0
    for d in range(dmin, H - 1, 2):
        poolsz = (d - 2) // 2
        cnt = sum(1 for i0 in range(poolsz)
                  if os.path.exists(f"par_jobs/p{k}_{d}_i{i0}.txt")
                  and os.path.getsize(f"par_jobs/p{k}_{d}_i{i0}.txt") > 0)
        if cnt >= poolsz:
            done_d += 1
    print(f"k={k}: d 完成 {done_d}/{total_d}")
EOF
