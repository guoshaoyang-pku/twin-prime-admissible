import Sound
import lean_certs.cert_46_106

open CertVerify

/-- 不存在直径 ≤ 106 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_106 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 46) (d := 106) (c := cert_46_106) (by native_decide)
