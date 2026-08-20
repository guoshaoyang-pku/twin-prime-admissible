import Sound
import lean_certs.cert_45_178

open CertVerify

/-- 不存在直径 ≤ 178 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_178 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 45) (d := 178) (c := cert_45_178) (by native_decide)
