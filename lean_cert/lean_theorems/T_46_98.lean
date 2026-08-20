import Sound
import lean_certs.cert_46_98

open CertVerify

/-- 不存在直径 ≤ 98 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_98 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 46) (d := 98) (c := cert_46_98) (by native_decide)
