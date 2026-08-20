import Sound
import lean_certs.cert_43_130

open CertVerify

/-- 不存在直径 ≤ 130 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_130 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 43) (d := 130) (c := cert_43_130) (by native_decide)
