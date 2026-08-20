import Sound
import lean_certs.cert_50_158

open CertVerify

/-- 不存在直径 ≤ 158 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_158 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 50) (d := 158) (c := cert_50_158) (by native_decide)
