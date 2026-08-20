import Sound
import lean_certs.cert_50_154

open CertVerify

/-- 不存在直径 ≤ 154 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_154 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 50) (d := 154) (c := cert_50_154) (by native_decide)
