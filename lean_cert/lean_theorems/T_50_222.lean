import Sound
import lean_certs.cert_50_222

open CertVerify

/-- 不存在直径 ≤ 222 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_222 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 222 := by
  exact certValidRoot_sound (k := 50) (d := 222) (c := cert_50_222) (by native_decide)
