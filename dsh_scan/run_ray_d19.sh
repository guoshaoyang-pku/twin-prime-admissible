#!/bin/bash
cd /data3/guoshaoyang/workdir/math/dsh_scan
for k in 49 48 47 46; do
  for eps in "1/10" "1/8" "1/6" "1/5"; do
    en=${eps%/*}; ed=${eps#*/}
    if [ -f frac_cache_${k}_19_e${en}_${ed}.pkl ]; then
      echo "##### k=$k eps=$eps #####" >> ray_d19.log
      timeout 2400 python3 rayleigh_check.py $k 19 $en $ed 8 30 >> ray_d19.log 2>&1
    fi
  done
done
echo "ALL DONE" >> ray_d19.log
