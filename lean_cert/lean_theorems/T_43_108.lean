import Sound
import lean_certs.cert_43_108

open CertVerify

/-- 不存在直径 ≤ 108 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_108 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 43) (d := 108) (c := cert_43_108) (by native_decide)
