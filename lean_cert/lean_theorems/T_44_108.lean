import Sound
import lean_certs.cert_44_108

open CertVerify

/-- 不存在直径 ≤ 108 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_108 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 44) (d := 108) (c := cert_44_108) (by native_decide)
