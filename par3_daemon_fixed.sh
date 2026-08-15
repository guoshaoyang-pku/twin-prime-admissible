#!/bin/bash
cd /data3/guoshaoyang/workdir/math
mkdir -p par3_locks
while true; do
  running=$(ps aux | grep -c "[a]dmissible_par3")
  if [ $running -lt 30 ]; then
    launched=0
    while read -r k d i0 j0 k0; do
      fn="par3_results/r_${k}_${d}_${i0}_${j0}_${k0}.txt"
      lock="par3_locks/l_${k}_${d}_${i0}_${j0}_${k0}"
      if [ ! -f "$fn" ] && [ ! -f "$lock" ]; then
        touch "$lock"
        nohup ./admissible_par3 $k $d $i0 $j0 $k0 > "$fn" 2>&1 &
        launched=$((launched+1))
        running=$((running+1))
        if [ $running -ge 30 ]; then break; fi
      fi
    done < par3_tasks.txt
    if [ $launched -eq 0 ]; then
      sleep 30
    fi
  else
    sleep 20
  fi
done
