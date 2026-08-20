import Sound
import lean_certs.cert_43_138

open CertVerify

/-- 不存在直径 ≤ 138 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_138 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 43) (d := 138) (c := cert_43_138) (by native_decide)
