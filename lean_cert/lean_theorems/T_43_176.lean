import Sound
import lean_certs.cert_43_176

open CertVerify

/-- 不存在直径 ≤ 176 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_176 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 43) (d := 176) (c := cert_43_176) (by native_decide)
