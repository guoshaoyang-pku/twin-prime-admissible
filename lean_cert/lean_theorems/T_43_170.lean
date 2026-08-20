import Sound
import lean_certs.cert_43_170

open CertVerify

/-- 不存在直径 ≤ 170 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_170 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 43) (d := 170) (c := cert_43_170) (by native_decide)
