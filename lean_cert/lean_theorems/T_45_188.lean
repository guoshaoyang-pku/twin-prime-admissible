import Sound
import lean_certs.cert_45_188

open CertVerify

/-- 不存在直径 ≤ 188 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_188 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 45) (d := 188) (c := cert_45_188) (by native_decide)
