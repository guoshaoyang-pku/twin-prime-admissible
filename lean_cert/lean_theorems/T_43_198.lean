import Sound
import lean_certs.cert_43_198

open CertVerify

/-- 不存在直径 ≤ 198 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_198 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 43) (d := 198) (c := cert_43_198) (by native_decide)
