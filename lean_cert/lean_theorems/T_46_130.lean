import Sound
import lean_certs.cert_46_130

open CertVerify

/-- 不存在直径 ≤ 130 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_130 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 46) (d := 130) (c := cert_46_130) (by native_decide)
