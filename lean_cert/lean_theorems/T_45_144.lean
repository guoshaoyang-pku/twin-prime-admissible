import Sound
import lean_certs.cert_45_144

open CertVerify

/-- 不存在直径 ≤ 144 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_144 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 45) (d := 144) (c := cert_45_144) (by native_decide)
