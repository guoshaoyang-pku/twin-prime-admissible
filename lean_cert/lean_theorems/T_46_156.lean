import Sound
import lean_certs.cert_46_156

open CertVerify

/-- 不存在直径 ≤ 156 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_156 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 46) (d := 156) (c := cert_46_156) (by native_decide)
