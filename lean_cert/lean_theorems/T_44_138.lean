import Sound
import lean_certs.cert_44_138

open CertVerify

/-- 不存在直径 ≤ 138 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_138 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 44) (d := 138) (c := cert_44_138) (by native_decide)
