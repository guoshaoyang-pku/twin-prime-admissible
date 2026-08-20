import Sound
import lean_certs.cert_45_174

open CertVerify

/-- 不存在直径 ≤ 174 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_174 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 45) (d := 174) (c := cert_45_174) (by native_decide)
