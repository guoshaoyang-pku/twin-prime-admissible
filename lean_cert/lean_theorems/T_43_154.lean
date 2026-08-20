import Sound
import lean_certs.cert_43_154

open CertVerify

/-- 不存在直径 ≤ 154 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_154 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 43) (d := 154) (c := cert_43_154) (by native_decide)
