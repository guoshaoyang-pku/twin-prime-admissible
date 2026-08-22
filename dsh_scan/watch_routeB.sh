#!/bin/bash
cd /data3/guoshaoyang/workdir/math/dsh_scan
while [ ! -f frac_cacheB_49_25_7_e1_25.pkl ]; do sleep 60; done
sleep 10
nohup timeout 18000 python3 rayleigh_mpfr.py 49 25 7 1 25 640 500 25 frac_cacheB_49_25_7_e1_25.pkl > mfrB49_dm7.log 2>&1 &
echo "launched rayleigh for DM=7 at $(date +%H:%M)" >> mfrB49_dm7.log
