import Sound
import lean_certs.cert_46_144

open CertVerify

/-- 不存在直径 ≤ 144 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_144 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 46) (d := 144) (c := cert_46_144) (by native_decide)
