import Sound
import lean_certs.cert_46_188

open CertVerify

/-- 不存在直径 ≤ 188 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_188 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 46) (d := 188) (c := cert_46_188) (by native_decide)
