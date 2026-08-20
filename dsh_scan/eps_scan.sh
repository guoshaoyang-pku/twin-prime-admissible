#!/bin/bash
# ε 扫描: k=44..50 × ε∈{1/50, 1/100} × D=8/12
for k in 44 45 46 47 48 49 50; do
  for eps in 1/50 1/100; do
    en=${eps%/*}; ed=${eps#*/}
    echo "===== k=$k eps=$eps ====="
    timeout 900 python3 dscan.py $k $en $ed 6 8 12 2>&1 | grep -E "M~"
  done
done > mscan_eps.log 2>&1
echo "EPS_SCAN_DONE"; cat mscan_eps.log
