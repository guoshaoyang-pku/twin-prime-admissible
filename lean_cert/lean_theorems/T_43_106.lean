import Sound
import lean_certs.cert_43_106

open CertVerify

/-- 不存在直径 ≤ 106 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_106 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 43) (d := 106) (c := cert_43_106) (by native_decide)
