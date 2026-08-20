import Sound
import lean_certs.cert_50_234

open CertVerify

/-- 不存在直径 ≤ 234 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_234 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 234 := by
  exact certValidRoot_sound (k := 50) (d := 234) (c := cert_50_234) (by native_decide)
