import Sound
import lean_certs.cert_46_198

open CertVerify

/-- 不存在直径 ≤ 198 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_198 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 46) (d := 198) (c := cert_46_198) (by native_decide)
