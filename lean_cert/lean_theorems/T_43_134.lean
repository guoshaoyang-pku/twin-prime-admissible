import Sound
import lean_certs.cert_43_134

open CertVerify

/-- 不存在直径 ≤ 134 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_134 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 43) (d := 134) (c := cert_43_134) (by native_decide)
