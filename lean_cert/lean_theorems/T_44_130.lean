import Sound
import lean_certs.cert_44_130

open CertVerify

/-- 不存在直径 ≤ 130 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_130 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 44) (d := 130) (c := cert_44_130) (by native_decide)
