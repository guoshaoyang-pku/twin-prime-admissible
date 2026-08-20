import Sound
import lean_certs.cert_50_238

open CertVerify

/-- 不存在直径 ≤ 238 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_238 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 238 := by
  exact certValidRoot_sound (k := 50) (d := 238) (c := cert_50_238) (by native_decide)
