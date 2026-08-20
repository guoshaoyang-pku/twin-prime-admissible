import Sound
import lean_certs.cert_43_90

open CertVerify

/-- 不存在直径 ≤ 90 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_90 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 43) (d := 90) (c := cert_43_90) (by native_decide)
