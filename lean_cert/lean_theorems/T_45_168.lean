import Sound
import lean_certs.cert_45_168

open CertVerify

/-- 不存在直径 ≤ 168 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_168 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 45) (d := 168) (c := cert_45_168) (by native_decide)
