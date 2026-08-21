#!/bin/bash
# D=16 与 D=20 全量: k=44..50 (并行 14 进程)
mkdir -p d16d20_out
for k in 44 45 46 47 48 49 50; do
  for D in 16 20; do
    (timeout 5400 python3 -u dscan.py $k 1 25 6 $D > d16d20_out/k${k}_D${D}.log 2>&1; echo "DONE k=$k D=$D" >> d16d20_out/status.txt) &
  done
done
wait
echo "ALL_D16D20_DONE"
