import Sound
import lean_certs.cert_44_122

open CertVerify

/-- 不存在直径 ≤ 122 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_122 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 44) (d := 122) (c := cert_44_122) (by native_decide)
