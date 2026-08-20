import Sound
import lean_certs.cert_45_170

open CertVerify

/-- 不存在直径 ≤ 170 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_170 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 45) (d := 170) (c := cert_45_170) (by native_decide)
