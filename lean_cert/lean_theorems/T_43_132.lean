import Sound
import lean_certs.cert_43_132

open CertVerify

/-- 不存在直径 ≤ 132 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_132 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 43) (d := 132) (c := cert_43_132) (by native_decide)
