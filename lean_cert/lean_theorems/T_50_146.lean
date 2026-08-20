import Sound
import lean_certs.cert_50_146

open CertVerify

/-- 不存在直径 ≤ 146 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_146 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 50) (d := 146) (c := cert_50_146) (by native_decide)
