import Sound
import lean_certs.cert_45_192

open CertVerify

/-- 不存在直径 ≤ 192 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_192 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 45) (d := 192) (c := cert_45_192) (by native_decide)
