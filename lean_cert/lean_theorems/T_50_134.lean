import Sound
import lean_certs.cert_50_134

open CertVerify

/-- 不存在直径 ≤ 134 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_134 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 50) (d := 134) (c := cert_50_134) (by native_decide)
