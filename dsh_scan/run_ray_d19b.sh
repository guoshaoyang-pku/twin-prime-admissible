#!/bin/bash
cd /data3/guoshaoyang/workdir/math/dsh_scan
for k in 49 48; do
  for eps in "1/25" "1/16"; do
    en=${eps%/*}; ed=${eps#*/}
    if [ -f frac_cache_${k}_19_e${en}_${ed}.pkl ]; then
      echo "##### k=$k eps=$eps #####" >> ray_d19b.log
      timeout 3600 python3 rayleigh_check.py $k 19 $en $ed 8 40 >> ray_d19b.log 2>&1
    fi
  done
done
echo "ALL DONE" >> ray_d19b.log
