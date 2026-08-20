import Sound
import lean_certs.cert_50_176

open CertVerify

/-- 不存在直径 ≤ 176 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_176 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 50) (d := 176) (c := cert_50_176) (by native_decide)
