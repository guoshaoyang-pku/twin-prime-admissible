#!/bin/bash
cd /data3/guoshaoyang/workdir/math
while true; do
  running=$(ps aux | grep -c "[a]dmissible_par3")
  if [ $running -lt 180 ]; then
    launched=0
    while read -r k d i0 j0 k0; do
      fn="par3_results/r_${k}_${d}_${i0}_${j0}_${k0}.txt"
      if [ ! -s "$fn" ]; then
        nohup ./admissible_par3 $k $d $i0 $j0 $k0 > "$fn" 2>&1 &
        launched=$((launched+1))
        running=$((running+1))
        if [ $running -ge 180 ]; then break; fi
      fi
    done < par3_tasks.txt
    if [ $launched -eq 0 ]; then
      done_count=$(ls par3_results/ | wc -l)
      total=44946
      if [ $done_count -ge $total ]; then
        echo "ALL_DONE" > par3_daemon_status.txt
        break
      fi
    fi
  fi
  sleep 20
done
