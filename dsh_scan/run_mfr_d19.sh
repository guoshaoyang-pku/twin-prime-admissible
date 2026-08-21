#!/bin/bash
cd /data3/guoshaoyang/workdir/math/dsh_scan
for spec in "48 1 25" "48 1 16" "48 1 10" "49 1 10" "49 1 8" "47 1 8" "46 1 8" "47 1 6" "46 1 6" "47 1 5" "46 1 5"; do
  set -- $spec; k=$1; en=$2; ed=$3
  if [ -f frac_cache_${k}_19_e${en}_${ed}.pkl ]; then
    echo "##### k=$k eps=$en/$ed #####" >> mfr_d19.log
    timeout 3600 python3 rayleigh_mpfr.py $k 19 $en $ed 640 250 25 >> mfr_d19.log 2>&1
  fi
done
echo "ALL DONE" >> mfr_d19.log
