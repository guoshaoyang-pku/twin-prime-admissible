#!/bin/bash
# ε=0 扫描: k=44..50 × D=8/12 (Maynard 原始判据 M_k)
for k in 44 45 46 47 48 49 50; do
  echo "===== k=$k eps=0 ====="
  timeout 900 python3 dscan.py $k 0 1 6 8 12 2>&1 | grep -E "M~"
done > mscan_eps0.log 2>&1
echo "EPS0_DONE"; cat mscan_eps0.log
