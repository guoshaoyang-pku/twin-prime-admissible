#!/usr/bin/env python3
"""生成 k=20..42 的 H(k) 下界证书与 Lean 定理"""
import sys, os, time
sys.path.insert(0, '.')
from cert_gen import gen_cert, serialize, verify

H_TABLE = {20:80,21:84,22:90,23:94,24:100,25:110,26:114,27:120,28:126,29:130,
           30:136,31:140,32:146,33:152,34:156,35:158,36:162,37:168,38:176,39:182,
           40:186,41:188,42:196}

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

total_targets = 0
t0 = time.time()
for k in range(20, 43):
    H = H_TABLE[k]
    for d in range(2 * (k - 1), H - 1, 2):
        total_targets += 1
        root, stats = gen_cert(k, d)
        assert root is not None, f"SAT at {k},{d}"
        txt = serialize(root)
        assert verify(txt, k, d)
        with open(f'certs/cert_{k}_{d}.txt', 'w') as f:
            f.write(txt)
        with open(f'lean_certs/cert_{k}_{d}.lean', 'w') as f:
            f.write(f'import CertVerify\n\n')
            f.write(f'def cert_{k}_{d} : CertVerify.Cert := {lean_tree(root, k, d)}\n')
        with open(f'lean_theorems/T_{k}_{d}.lean', 'w') as f:
            f.write(f'import Sound\nimport lean_certs.cert_{k}_{d}\n\n')
            f.write(f'open CertVerify\n\n')
            f.write(f'theorem H{k}_gt_{d} : ¬ ∃ t : List Nat, admissible {k} t = true ∧ diameter t ≤ {d} := by\n')
            f.write(f'  exact certValidRoot_sound (k := {k}) (d := {d}) (c := cert_{k}_{d}) (by native_decide)\n')
    print(f"k={k} H={H} done ({time.time()-t0:.0f}s)", flush=True)
print(f"TOTAL targets: {total_targets}")
