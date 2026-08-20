import Sound
import lean_certs.cert_46_114

open CertVerify

/-- 不存在直径 ≤ 114 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_114 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 46) (d := 114) (c := cert_46_114) (by native_decide)
