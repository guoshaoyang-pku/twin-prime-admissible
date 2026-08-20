#!/usr/bin/env python3
"""生成 Lean 证书定义文件: 每个 (k,d) 一个 .lean 文件, 内含 Cert 树字面量"""
import sys
sys.path.insert(0, '.')
from cert_gen import gen_cert, primes_upto
import os

TARGETS = []
for _k, _H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        TARGETS.append((_k, _d))

def lean_tree(node, k, d):
    """输出 Lean 语法 Cert 树 (branch p classes [children...])"""
    if node == 'L':
        return 'CertVerify.Cert.leaf'
    _, p, parts = node
    maxc = min(p - 1, d)
    classes = list(range(1, maxc + 1))
    if p > d + 1:
        classes.append(d + 1)
    cls = '[' + ', '.join(map(str, classes)) + ']'
    kids = '[' + ', '.join(lean_tree(ch, k, d) for ch in parts) + ']'
    return f'CertVerify.Cert.branch {p} {cls} {kids}'

os.makedirs('lean_certs', exist_ok=True)
total = 0
for k, d in TARGETS:
    root, stats = gen_cert(k, d)
    assert root is not None, f"SAT at {k},{d}"
    tree = lean_tree(root, k, d)
    with open(f'lean_certs/cert_{k}_{d}.lean', 'w') as f:
        f.write(f'import CertVerify\n\n')
        f.write(f'/-- UNSAT 证书: 不存在直径 ≤ {d} 的可容许 {k} 元组 -/\n')
        f.write(f'def cert_{k}_{d} : CertVerify.Cert := {tree}\n')
    total += len(tree)
print(f"done {len(TARGETS)} files, total {total} chars")
