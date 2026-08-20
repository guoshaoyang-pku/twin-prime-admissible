import Sound
import lean_certs.cert_50_236

open CertVerify

/-- 不存在直径 ≤ 236 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_236 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 236 := by
  exact certValidRoot_sound (k := 50) (d := 236) (c := cert_50_236) (by native_decide)
