import Sound
import lean_certs.cert_46_176

open CertVerify

/-- 不存在直径 ≤ 176 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_176 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 46) (d := 176) (c := cert_46_176) (by native_decide)
