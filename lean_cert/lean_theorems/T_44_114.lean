import Sound
import lean_certs.cert_44_114

open CertVerify

/-- 不存在直径 ≤ 114 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_114 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 44) (d := 114) (c := cert_44_114) (by native_decide)
