import Sound
import lean_certs.cert_45_124

open CertVerify

/-- 不存在直径 ≤ 124 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_124 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 45) (d := 124) (c := cert_45_124) (by native_decide)
