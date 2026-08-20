import Sound
import lean_certs.cert_43_98

open CertVerify

/-- 不存在直径 ≤ 98 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_98 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 43) (d := 98) (c := cert_43_98) (by native_decide)
