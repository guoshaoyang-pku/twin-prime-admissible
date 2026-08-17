#!/bin/bash
# clean_restart.sh — 可靠清理并重启 unified daemon
cd /data3/guoshaoyang/workdir/math
# 1. 杀所有 unified daemon (通过 /proc 精确匹配 python 命令行)
for d in /proc/[0-9]*; do
  pid=${d#/proc/}
  if [ -r "$d/cmdline" ]; then
    if tr '\0' ' ' < "$d/cmdline" 2>/dev/null | grep -q "unified_daemon.py"; then
      kill -9 "$pid" 2>/dev/null
      echo "killed daemon $pid"
    fi
  fi
done
sleep 2
# 2. 杀所有 worker
for bin in admissible_par admissible_par2 admissible_par3 admissible_par4 admissible_par5 admissible_par6; do
  pkill -9 -x "$bin" 2>/dev/null
done
sleep 2
# 3. 确认干净
echo "剩余 daemon: $(ls /proc/[0-9]*/cmdline 2>/dev/null | while read f; do tr '\0' ' ' < "$f" 2>/dev/null | grep -c unified_daemon.py; done | paste -sd+ | bc 2>/dev/null || echo 0)"
# 4. 启动新 daemon
setsid nohup python3 unified_daemon.py </dev/null > unified_daemon.log 2>&1 &
echo "started new daemon"
sleep 3
ps -eo pid,args | grep "[u]nified_daemon.py" | grep -v grep
