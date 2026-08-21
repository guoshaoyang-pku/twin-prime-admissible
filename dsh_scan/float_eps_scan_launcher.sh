#!/bin/bash
cd /data3/guoshaoyang/workdir/math/dsh_scan
for k in 49 48 47 46; do
  timeout 2400 python3 eps_scan.py $k 16 1/16 1/12 1/10 1/8 1/6 1/5 1/4 > epscan${k}d16.log 2>&1
done
echo "ALL DONE" >> epscan_all.log
