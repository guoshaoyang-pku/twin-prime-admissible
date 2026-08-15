#!/bin/bash
# 监控 admissible_par3 进程，超时（>25 分钟 CPU）的任务拆分到四级
cd /data3/guoshaoyang/workdir/math
mkdir -p par4_tasks_done par4_results
while true; do
  ps aux | grep "[a]dmissible_par3" | while read -r line; do
    pid=$(echo "$line" | awk '{print $2}')
    cput=$(echo "$line" | awk '{print $10}')
    # TIME 格式 M:SS 或 H:MM:SS
    if [[ "$cput" == *:*:* ]]; then
      mins=$(( ${cput%%:*} * 60 + 10#${cput#*:} / 60 ))
    else
      mins=$(( 10#${cput%%:*} ))
    fi
    if [ "$mins" -ge 25 ]; then
      args=$(ps -p $pid -o args= | sed 's/.*admissible_par3 //')
      k=$(echo $args | awk '{print $1}'); d=$(echo $args | awk '{print $2}')
      i0=$(echo $args | awk '{print $3}'); j0=$(echo $args | awk '{print $4}'); k0=$(echo $args | awk '{print $5}')
      mark="par4_tasks_done/m_${k}_${d}_${i0}_${j0}_${k0}"
      if [ ! -f "$mark" ]; then
        touch "$mark"
        kill -9 $pid 2>/dev/null
        sz=$(( (d-4)/2 ))
        for k1 in $(seq $((k0+1)) $sz); do
          echo "$k $d $i0 $j0 $k0 $k1" >> par4_tasks.txt
        done
        echo "SPLIT: $k $d $i0 $j0 $k0" >> par4_split_log.txt
      fi
    fi
  done
  sleep 60
done
