import Sound
import lean_certs.cert_43_84

open CertVerify

/-- 不存在直径 ≤ 84 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_84 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 43) (d := 84) (c := cert_43_84) (by native_decide)
