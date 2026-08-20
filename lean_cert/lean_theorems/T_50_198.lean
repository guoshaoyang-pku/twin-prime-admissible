import Sound
import lean_certs.cert_50_198

open CertVerify

/-- 不存在直径 ≤ 198 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_198 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 50) (d := 198) (c := cert_50_198) (by native_decide)
