import Sound
import lean_certs.cert_43_192

open CertVerify

/-- 不存在直径 ≤ 192 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_192 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 43) (d := 192) (c := cert_43_192) (by native_decide)
