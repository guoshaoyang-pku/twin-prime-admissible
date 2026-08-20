import Sound
import lean_certs.cert_45_102

open CertVerify

/-- 不存在直径 ≤ 102 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_102 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 45) (d := 102) (c := cert_45_102) (by native_decide)
