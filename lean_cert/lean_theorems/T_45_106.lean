import Sound
import lean_certs.cert_45_106

open CertVerify

/-- 不存在直径 ≤ 106 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_106 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 45) (d := 106) (c := cert_45_106) (by native_decide)
