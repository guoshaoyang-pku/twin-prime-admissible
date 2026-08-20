import Sound
import lean_certs.cert_50_180

open CertVerify

/-- 不存在直径 ≤ 180 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_180 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 50) (d := 180) (c := cert_50_180) (by native_decide)
