import Sound
import lean_certs.cert_45_132

open CertVerify

/-- 不存在直径 ≤ 132 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_132 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 45) (d := 132) (c := cert_45_132) (by native_decide)
