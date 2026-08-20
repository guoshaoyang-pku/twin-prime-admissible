import Sound
import lean_certs.cert_45_116

open CertVerify

/-- 不存在直径 ≤ 116 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_116 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 45) (d := 116) (c := cert_45_116) (by native_decide)
