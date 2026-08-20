#!/usr/bin/env python3
"""扩展: k=47,48,49 的 H(k) 下界证书 (共 210 个目标)"""
import sys, os, time
sys.path.insert(0, '.')
from cert_gen import gen_cert, serialize, verify

NEW_TARGETS = []
for _k, _H in [(47, 226), (48, 236), (49, 240)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        NEW_TARGETS.append((_k, _d))
print(f"new targets: {len(NEW_TARGETS)}")

def lean_tree(node, k, d):
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

os.makedirs('certs', exist_ok=True)
os.makedirs('certs_num', exist_ok=True)
os.makedirs('lean_certs', exist_ok=True)
os.makedirs('lean_theorems', exist_ok=True)

t0 = time.time()
for k, d in NEW_TARGETS:
    root, stats = gen_cert(k, d)
    assert root is not None, f"SAT at {k},{d}"
    # 文本证书
    txt = serialize(root)
    assert verify(txt, k, d)
    with open(f'certs/cert_{k}_{d}.txt', 'w') as f:
        f.write(txt)
    # 数字证书
    def ser_num(node):
        if node == 'L':
            return [0]
        _, p, parts = node
        return [p + 1] + sum((ser_num(ch) for ch in parts), [])
    nums = ser_num(root)
    with open(f'certs_num/cert_{k}_{d}.txt', 'w') as f:
        f.write(' '.join(map(str, nums)))
    # Lean 证书定义
    with open(f'lean_certs/cert_{k}_{d}.lean', 'w') as f:
        f.write(f'import CertVerify\n\n')
        f.write(f'/-- UNSAT 证书: 不存在直径 ≤ {d} 的可容许 {k} 元组 -/\n')
        f.write(f'def cert_{k}_{d} : CertVerify.Cert := {lean_tree(root, k, d)}\n')
    # Lean 定理
    with open(f'lean_theorems/T_{k}_{d}.lean', 'w') as f:
        f.write(f'import Sound\nimport lean_certs.cert_{k}_{d}\n\n')
        f.write(f'open CertVerify\n\n')
        f.write(f'theorem H{k}_gt_{d} : ¬ ∃ t : List Nat, admissible {k} t = true ∧ diameter t ≤ {d} := by\n')
        f.write(f'  exact certValidRoot_sound (k := {k}) (d := {d}) (c := cert_{k}_{d}) (by native_decide)\n')
print(f"generated in {time.time()-t0:.1f}s")
