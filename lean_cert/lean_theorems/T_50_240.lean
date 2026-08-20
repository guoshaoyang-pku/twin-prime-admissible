import Sound
import lean_certs.cert_50_240

open CertVerify

/-- 不存在直径 ≤ 240 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_240 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 240 := by
  exact certValidRoot_sound (k := 50) (d := 240) (c := cert_50_240) (by native_decide)
