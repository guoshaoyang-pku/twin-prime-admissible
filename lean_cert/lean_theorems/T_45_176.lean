import Sound
import lean_certs.cert_45_176

open CertVerify

/-- 不存在直径 ≤ 176 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_176 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 45) (d := 176) (c := cert_45_176) (by native_decide)
