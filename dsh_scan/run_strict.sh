#!/bin/bash
cd "$(dirname "$0")"
for k in 44 45 46 47 48 49 50; do
  (timeout 14400 python3 -u strict_m4.py $k > strict_k${k}.log 2>&1; echo "EXIT=$?" >> strict_k${k}.log) &
done
wait
echo ALL_STRICT_DONE
