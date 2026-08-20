import Sound
import lean_certs.cert_46_154

open CertVerify

/-- 不存在直径 ≤ 154 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_154 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 46) (d := 154) (c := cert_46_154) (by native_decide)
