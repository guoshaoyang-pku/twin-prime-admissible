#!/bin/bash
cd /data3/guoshaoyang/workdir/math
total=$(wc -l < par2_tasks.txt)
i=0
while [ $i -lt $total ]; do
  running=$(ps aux | grep -c "[a]dmissible_par2")
  if [ $running -lt 185 ]; then
    i=$((i+1))
    line=$(sed -n "${i}p" par2_tasks.txt)
    if [ -n "$line" ]; then
      set -- $line
      if [ ! -s "par2_results/r_$1_$2_$3_$4.txt" ]; then
        nohup ./admissible_par2 $1 $2 $3 $4 > "par2_results/r_$1_$2_$3_$4.txt" 2>&1 &
      fi
    fi
  else
    sleep 10
  fi
done
echo "ALL_SUBMITTED"
wait
echo "ALL_DONE"
