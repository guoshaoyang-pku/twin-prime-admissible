import Sound
import lean_certs.cert_46_102

open CertVerify

/-- 不存在直径 ≤ 102 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_102 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 46) (d := 102) (c := cert_46_102) (by native_decide)
