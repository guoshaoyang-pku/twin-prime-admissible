import Sound
import lean_certs.cert_46_122

open CertVerify

/-- 不存在直径 ≤ 122 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_122 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 46) (d := 122) (c := cert_46_122) (by native_decide)
