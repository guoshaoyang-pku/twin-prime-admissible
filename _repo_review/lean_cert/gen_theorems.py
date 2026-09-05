#!/usr/bin/env python3
"""生成 319 个 UNSAT 主定理文件: theorem Hk_gt_d : ¬ ∃ t, admissible k t ∧ diameter t ≤ d"""
import os

TARGETS = []
for _k, _H in [(43, 200), (44, 210), (45, 212), (46, 216), (50, 246)]:
    for _d in range(2 * (_k - 1), _H - 1, 2):
        TARGETS.append((_k, _d))

os.makedirs('lean_theorems', exist_ok=True)
for k, d in TARGETS:
    with open(f'lean_theorems/T_{k}_{d}.lean', 'w') as f:
        f.write(f'import CertVerify\nimport lean_certs.cert_{k}_{d}\n\n')
        f.write(f'open CertVerify\n\n')
        f.write(f'/-- 不存在直径 ≤ {d} 的可容许 {k} 元组 (UNSAT 证书机器验证) -/\n')
        f.write(f'theorem H{k}_gt_{d} : ¬ ∃ t : List Nat, admissible {k} t = true ∧ diameter t ≤ {d} := by\n')
        f.write(f'  exact certValidRoot_sound (k := {k}) (d := {d}) (c := cert_{k}_{d}) (by native_decide)\n')
print(f"generated {len(TARGETS)} theorem files")
