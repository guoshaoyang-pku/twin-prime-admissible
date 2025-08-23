#!/bin/bash
# routeB_run_verify.sh — 路线B 证书独立验证 (软链证书名 + routeB_verify)
# 用法: ./routeB_run_verify.sh [k] [DP] [DM] [en] [ed]
cd /data4/guoshaoyang/dsh_scan2
K=${1:-49}; DP=${2:-25}; DM=${3:-7}; EN=${4:-1}; ED=${5:-25}
WIN="rayleigh_win_${K}_${DP}_e${EN}_${ED}.json"
WINB="rayleigh_win_B_${K}_${DP}_${DM}_e${EN}_${ED}.json"
if [ ! -f "$WIN" ]; then echo "no certificate $WIN yet"; exit 1; fi
ln -sf "$WIN" "$WINB"
python3 /data3/guoshaoyang/workdir/math/dsh_scan/routeB_verify.py "$K" "$DP" "$DM" "$EN" "$ED"
