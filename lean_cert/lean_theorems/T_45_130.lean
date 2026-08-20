import Sound
import lean_certs.cert_45_130

open CertVerify

/-- 不存在直径 ≤ 130 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_130 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 45) (d := 130) (c := cert_45_130) (by native_decide)
