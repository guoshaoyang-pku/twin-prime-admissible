import Sound
import lean_certs.cert_45_146

open CertVerify

/-- 不存在直径 ≤ 146 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_146 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 45) (d := 146) (c := cert_45_146) (by native_decide)
