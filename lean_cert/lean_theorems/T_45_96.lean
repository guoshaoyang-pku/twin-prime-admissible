import Sound
import lean_certs.cert_45_96

open CertVerify

/-- 不存在直径 ≤ 96 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_96 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 45) (d := 96) (c := cert_45_96) (by native_decide)
