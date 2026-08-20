import Sound
import lean_certs.cert_43_156

open CertVerify

/-- 不存在直径 ≤ 156 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_156 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 43) (d := 156) (c := cert_43_156) (by native_decide)
