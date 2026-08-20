import Sound
import lean_certs.cert_45_108

open CertVerify

/-- 不存在直径 ≤ 108 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_108 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 45) (d := 108) (c := cert_45_108) (by native_decide)
