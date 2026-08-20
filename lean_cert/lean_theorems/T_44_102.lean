import Sound
import lean_certs.cert_44_102

open CertVerify

/-- 不存在直径 ≤ 102 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_102 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 44) (d := 102) (c := cert_44_102) (by native_decide)
