import Sound
import lean_certs.cert_50_130

open CertVerify

/-- 不存在直径 ≤ 130 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_130 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 50) (d := 130) (c := cert_50_130) (by native_decide)
