import Sound
import lean_certs.cert_50_156

open CertVerify

/-- 不存在直径 ≤ 156 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_156 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 50) (d := 156) (c := cert_50_156) (by native_decide)
