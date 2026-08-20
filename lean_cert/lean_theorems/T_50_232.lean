import Sound
import lean_certs.cert_50_232

open CertVerify

/-- 不存在直径 ≤ 232 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_232 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 232 := by
  exact certValidRoot_sound (k := 50) (d := 232) (c := cert_50_232) (by native_decide)
