#!/usr/bin/env python3
"""生成数字编码证书: 'L'→0, 'B p'→p+1 (p>=2 故与 0 区分)"""
import sys
sys.path.insert(0, '.')
from cert_gen import gen_cert
import os

TARGETS = []
for _k, _H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        TARGETS.append((_k, _d))

def serialize_num(node):
    if node == 'L':
        return [0]
    _, p, parts = node
    return [p + 1] + sum((serialize_num(ch) for ch in parts), [])

os.makedirs('certs_num', exist_ok=True)
total = 0
for k, d in TARGETS:
    root, stats = gen_cert(k, d)
    assert root is not None
    nums = serialize_num(root)
    with open(f'certs_num/cert_{k}_{d}.txt', 'w') as f:
        f.write(' '.join(map(str, nums)))
    total += len(nums)
print(f"done, total tokens={total}")
