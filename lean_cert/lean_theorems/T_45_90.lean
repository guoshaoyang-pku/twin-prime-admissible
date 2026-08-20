import Sound
import lean_certs.cert_45_90

open CertVerify

/-- 不存在直径 ≤ 90 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_90 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 45) (d := 90) (c := cert_45_90) (by native_decide)
