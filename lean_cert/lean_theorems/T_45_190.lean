import Sound
import lean_certs.cert_45_190

open CertVerify

/-- 不存在直径 ≤ 190 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_190 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 45) (d := 190) (c := cert_45_190) (by native_decide)
