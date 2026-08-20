import Sound
import lean_certs.cert_50_192

open CertVerify

/-- 不存在直径 ≤ 192 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_192 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 50) (d := 192) (c := cert_50_192) (by native_decide)
