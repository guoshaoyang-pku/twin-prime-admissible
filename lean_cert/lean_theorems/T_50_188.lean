import Sound
import lean_certs.cert_50_188

open CertVerify

/-- 不存在直径 ≤ 188 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_188 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 50) (d := 188) (c := cert_50_188) (by native_decide)
