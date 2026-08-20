import Sound
import lean_certs.cert_44_106

open CertVerify

/-- 不存在直径 ≤ 106 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_106 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 44) (d := 106) (c := cert_44_106) (by native_decide)
