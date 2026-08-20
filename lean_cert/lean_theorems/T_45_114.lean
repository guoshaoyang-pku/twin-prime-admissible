import Sound
import lean_certs.cert_45_114

open CertVerify

/-- 不存在直径 ≤ 114 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_114 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 45) (d := 114) (c := cert_45_114) (by native_decide)
