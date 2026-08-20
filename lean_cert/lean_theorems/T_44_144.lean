import Sound
import lean_certs.cert_44_144

open CertVerify

/-- 不存在直径 ≤ 144 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_144 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 44) (d := 144) (c := cert_44_144) (by native_decide)
