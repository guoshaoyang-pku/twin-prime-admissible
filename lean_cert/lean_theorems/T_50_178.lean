import Sound
import lean_certs.cert_50_178

open CertVerify

/-- 不存在直径 ≤ 178 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_178 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 50) (d := 178) (c := cert_50_178) (by native_decide)
