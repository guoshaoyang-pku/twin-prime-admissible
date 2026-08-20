#!/bin/bash
# 并行编译全部证书与定理
cd /data3/guoshaoyang/workdir/math/lean_cert
export LEAN_PATH=.
LEAN=../lean-4.33.0-linux/bin/lean
mkdir -p lean_theorems
# 1. 证书
ls lean_certs/*.lean | xargs -P 48 -I {} sh -c 'f="$1"; o="${f%.lean}.olean"; if [ ! -f "$o" ]; then '"$LEAN"' -o "$o" "$f" > /dev/null 2>&1 || echo "CERT-FAIL $f"; fi' _ {}
echo "CERTS DONE: $(ls lean_certs/*.olean | wc -l)/319"
# 2. 定理 (native_decide 执行验证器)
ls lean_theorems/*.lean | xargs -P 32 -I {} sh -c 'f="$1"; o="${f%.lean}.olean"; '"$LEAN"' -o "$o" "$f" > /dev/null 2>&1 || echo "THM-FAIL $f"' _ {}
echo "THEOREMS DONE"
ls lean_theorems/*.olean | wc -l
