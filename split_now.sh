#!/bin/bash
# 手动拆分 par3 难任务（>25 分钟）为四级
cd /data3/guoshaoyang/workdir/math
for pid in $(pgrep -f "admissible_par3 "); do
  et=$(ps -p $pid -o etimes= 2>/dev/null | tr -d ' ')
  if [ -n "$et" ] && [ "$et" -gt 1500 ]; then
    args=$(ps -p $pid -o args= 2>/dev/null | tr -s ' ')
    k=$(echo "$args" | awk '{print $2}')
    d=$(echo "$args" | awk '{print $3}')
    i0=$(echo "$args" | awk '{print $4}')
    j0=$(echo "$args" | awk '{print $5}')
    k0=$(echo "$args" | awk '{print $6}')
    if [ -n "$k" ] && [ -n "$d" ] && [ "$d" -gt 0 ]; then
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
  fi
done
echo "DONE"
