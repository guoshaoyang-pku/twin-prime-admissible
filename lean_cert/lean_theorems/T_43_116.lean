import Sound
import lean_certs.cert_43_116

open CertVerify

/-- 不存在直径 ≤ 116 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_116 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 43) (d := 116) (c := cert_43_116) (by native_decide)
