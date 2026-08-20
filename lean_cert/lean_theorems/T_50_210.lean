import Sound
import lean_certs.cert_50_210

open CertVerify

/-- 不存在直径 ≤ 210 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_210 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 50) (d := 210) (c := cert_50_210) (by native_decide)
