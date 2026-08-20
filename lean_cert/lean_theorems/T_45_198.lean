import Sound
import lean_certs.cert_45_198

open CertVerify

/-- 不存在直径 ≤ 198 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_198 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 45) (d := 198) (c := cert_45_198) (by native_decide)
