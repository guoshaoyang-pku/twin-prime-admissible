import Sound
import lean_certs.cert_43_158

open CertVerify

/-- 不存在直径 ≤ 158 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_158 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 43) (d := 158) (c := cert_43_158) (by native_decide)
