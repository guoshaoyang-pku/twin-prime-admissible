import Sound
import lean_certs.cert_45_140

open CertVerify

/-- 不存在直径 ≤ 140 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_140 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 45) (d := 140) (c := cert_45_140) (by native_decide)
