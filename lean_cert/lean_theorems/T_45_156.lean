import Sound
import lean_certs.cert_45_156

open CertVerify

/-- 不存在直径 ≤ 156 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_156 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 45) (d := 156) (c := cert_45_156) (by native_decide)
