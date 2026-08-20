import Sound
import lean_certs.cert_50_122

open CertVerify

/-- 不存在直径 ≤ 122 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_122 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 50) (d := 122) (c := cert_50_122) (by native_decide)
