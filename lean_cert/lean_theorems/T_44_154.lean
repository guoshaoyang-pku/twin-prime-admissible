import Sound
import lean_certs.cert_44_154

open CertVerify

/-- 不存在直径 ≤ 154 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_154 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 44) (d := 154) (c := cert_44_154) (by native_decide)
