import Sound
import lean_certs.cert_50_174

open CertVerify

/-- 不存在直径 ≤ 174 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_174 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 50) (d := 174) (c := cert_50_174) (by native_decide)
