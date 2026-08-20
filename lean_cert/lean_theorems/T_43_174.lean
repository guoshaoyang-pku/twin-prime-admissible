import Sound
import lean_certs.cert_43_174

open CertVerify

/-- 不存在直径 ≤ 174 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_174 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 43) (d := 174) (c := cert_43_174) (by native_decide)
