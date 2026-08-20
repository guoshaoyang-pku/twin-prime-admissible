import Sound
import lean_certs.cert_44_198

open CertVerify

/-- 不存在直径 ≤ 198 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_198 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 44) (d := 198) (c := cert_44_198) (by native_decide)
