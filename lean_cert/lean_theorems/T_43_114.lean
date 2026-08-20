import Sound
import lean_certs.cert_43_114

open CertVerify

/-- 不存在直径 ≤ 114 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_114 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 43) (d := 114) (c := cert_43_114) (by native_decide)
