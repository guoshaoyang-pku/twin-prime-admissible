#!/bin/bash
cd /data3/guoshaoyang/workdir/math
while true; do
  running=$(ps aux | grep -c "[a]dmissible_par4")
  if [ $running -lt 30 ]; then
    launched=0
    while read -r k d i0 j0 k0 k1; do
      fn="par4_results/r_${k}_${d}_${i0}_${j0}_${k0}_${k1}.txt"
      if [ ! -s "$fn" ]; then
        nohup ./admissible_par4 $k $d $i0 $j0 $k0 $k1 > "$fn" 2>&1 &
        launched=$((launched+1))
        running=$((running+1))
        if [ $running -ge 30 ]; then break; fi
      fi
    done < par4_tasks.txt
    if [ $launched -eq 0 ]; then
      sleep 60
    fi
  else
    sleep 30
  fi
done
