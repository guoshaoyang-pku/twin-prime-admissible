import Sound
import lean_certs.cert_46_138

open CertVerify

/-- 不存在直径 ≤ 138 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_138 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 46) (d := 138) (c := cert_46_138) (by native_decide)
