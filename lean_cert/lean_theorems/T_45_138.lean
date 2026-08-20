import Sound
import lean_certs.cert_45_138

open CertVerify

/-- 不存在直径 ≤ 138 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_138 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 45) (d := 138) (c := cert_45_138) (by native_decide)
