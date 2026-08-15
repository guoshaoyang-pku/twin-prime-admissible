#!/bin/bash
cd /data3/guoshaoyang/workdir/math
mkdir -p par2rest_results par2rest_locks
while true; do
  running=$(ps aux | grep -c "[a]dmissible_par2")
  if [ $running -lt 90 ]; then
    launched=0
    while read -r k d i0 j0; do
      fn="par2rest_results/r_${k}_${d}_${i0}_${j0}.txt"
      lock="par2rest_locks/l_${k}_${d}_${i0}_${j0}"
      if [ ! -f "$fn" ] && [ ! -f "$lock" ]; then
        touch "$lock"
        nohup ./admissible_par2 $k $d $i0 $j0 > "$fn" 2>&1 &
        launched=$((launched+1))
        running=$((running+1))
        if [ $running -ge 90 ]; then break; fi
      fi
    done < par2rest_tasks.txt
    if [ $launched -eq 0 ]; then
      sleep 30
    fi
  else
    sleep 20
  fi
done
