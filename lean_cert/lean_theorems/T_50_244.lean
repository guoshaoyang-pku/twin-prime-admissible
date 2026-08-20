import Sound
import lean_certs.cert_50_244

open CertVerify

/-- 不存在直径 ≤ 244 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_244 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 244 := by
  exact certValidRoot_sound (k := 50) (d := 244) (c := cert_50_244) (by native_decide)
