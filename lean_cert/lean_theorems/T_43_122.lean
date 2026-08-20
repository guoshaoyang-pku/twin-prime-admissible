import Sound
import lean_certs.cert_43_122

open CertVerify

/-- 不存在直径 ≤ 122 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_122 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 43) (d := 122) (c := cert_43_122) (by native_decide)
