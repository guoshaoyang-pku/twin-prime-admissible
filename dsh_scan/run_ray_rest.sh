#!/bin/bash
cd /data3/guoshaoyang/workdir/math/dsh_scan
for spec in "49 1 16" "48 1 25" "48 1 16" "49 1 8" "49 1 6" "49 1 5" "48 1 10" "48 1 8" "48 1 6" "47 1 8" "47 1 6" "47 1 5" "46 1 8" "46 1 6"; do
  set -- $spec; k=$1; en=$2; ed=$3
  if [ -f frac_cache_${k}_19_e${en}_${ed}.pkl ]; then
    echo "##### k=$k eps=$en/$ed #####" >> ray_rest.log
    timeout 3000 python3 rayleigh_check.py $k 19 $en $ed 8 40 >> ray_rest.log 2>&1
  fi
done
echo "ALL DONE" >> ray_rest.log
