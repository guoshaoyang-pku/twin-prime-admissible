import Sound
import lean_certs.cert_50_184

open CertVerify

/-- 不存在直径 ≤ 184 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_184 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 50) (d := 184) (c := cert_50_184) (by native_decide)
