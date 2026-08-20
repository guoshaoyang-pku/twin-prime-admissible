import Sound
import lean_certs.cert_43_188

open CertVerify

/-- 不存在直径 ≤ 188 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_188 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 43) (d := 188) (c := cert_43_188) (by native_decide)
