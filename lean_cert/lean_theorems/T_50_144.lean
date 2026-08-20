import Sound
import lean_certs.cert_50_144

open CertVerify

/-- 不存在直径 ≤ 144 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_144 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 50) (d := 144) (c := cert_50_144) (by native_decide)
