#!/bin/bash
cd "$(dirname "$0")"
for k in 44 45 46 47 48 49 50; do
  (timeout 7200 python3 -u decide_one.py $k > decide_k${k}.log 2>&1; echo "EXIT=$?" >> decide_k${k}.log) &
done
wait
echo ALL_DECIDE_DONE
