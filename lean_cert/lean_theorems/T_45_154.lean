import Sound
import lean_certs.cert_45_154

open CertVerify

/-- 不存在直径 ≤ 154 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_154 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 45) (d := 154) (c := cert_45_154) (by native_decide)
