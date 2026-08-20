#!/bin/bash
# 并行编译全部 319 证书与 319 定理
# 用法: ./build_all.sh [lean 可执行文件路径]
#   默认从 PATH 查找 lean; 也可设置环境变量 LEAN_BIN
set -u
cd "$(dirname "$0")"

# 定位 lean
if [ -n "${LEAN_BIN:-}" ]; then
  LEAN="$LEAN_BIN"
elif [ -n "${1:-}" ]; then
  LEAN="$1"
else
  LEAN="$(command -v lean || true)"
fi
if [ -z "$LEAN" ] || [ ! -x "$LEAN" ]; then
  echo "ERROR: lean not found. Pass path as argument or set LEAN_BIN." >&2
  exit 1
fi
echo "Using lean: $LEAN"

export LEAN_PATH=.
NPROC="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 8)"
CERT_PAR="$(( NPROC / 4 < 48 ? NPROC / 4 : 48 ))"
THM_PAR="$(( NPROC / 6 < 32 ? NPROC / 6 : 32 ))"
[ "$CERT_PAR" -lt 1 ] && CERT_PAR=1
[ "$THM_PAR" -lt 1 ] && THM_PAR=1

# 1. 证书定义
ls lean_certs/*.lean 2>/dev/null | xargs -P "$CERT_PAR" -I {} sh -c \
  'f="$1"; o="${f%.lean}.olean"; if [ ! -f "$o" ]; then '"$LEAN"' -o "$o" "$f" > /dev/null 2>&1 || echo "CERT-FAIL $f"; fi' _ {}
echo "CERTS DONE: $(ls lean_certs/*.olean 2>/dev/null | wc -l)/319"

# 2. 定理 (native_decide 执行验证器)
ls lean_theorems/*.lean 2>/dev/null | xargs -P "$THM_PAR" -I {} sh -c \
  'f="$1"; o="${f%.lean}.olean"; '"$LEAN"' -o "$o" "$f" > /dev/null 2>&1 || echo "THM-FAIL $f"' _ {}
echo "THEOREMS DONE: $(ls lean_theorems/*.olean 2>/dev/null | wc -l)/319"
