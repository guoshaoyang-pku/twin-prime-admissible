import Sound
import lean_certs.cert_44_174

open CertVerify

/-- 不存在直径 ≤ 174 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_174 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 44) (d := 174) (c := cert_44_174) (by native_decide)
