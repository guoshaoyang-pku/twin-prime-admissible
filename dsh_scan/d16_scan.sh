#!/bin/bash
# D=16/20 补尾: k=44..50, ε=1/25, r=6 (加大 timeout)
for k in 44 45 46 47 48 49 50; do
  echo "===== k=$k eps=1/25 D=16/20 ====="
  timeout 1800 python3 dscan.py $k 1 25 6 16 20 2>&1 | grep -E "M~"
done > mscan_d16.log 2>&1
echo "D16_DONE"; cat mscan_d16.log
