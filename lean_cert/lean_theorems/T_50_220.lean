import Sound
import lean_certs.cert_50_220

open CertVerify

/-- 不存在直径 ≤ 220 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_220 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 220 := by
  exact certValidRoot_sound (k := 50) (d := 220) (c := cert_50_220) (by native_decide)
