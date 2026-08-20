import Sound
import lean_certs.cert_46_90

open CertVerify

/-- 不存在直径 ≤ 90 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_90 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 46) (d := 90) (c := cert_46_90) (by native_decide)
