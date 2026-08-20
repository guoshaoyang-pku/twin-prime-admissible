import Sound
import lean_certs.cert_50_124

open CertVerify

/-- 不存在直径 ≤ 124 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_124 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 50) (d := 124) (c := cert_50_124) (by native_decide)
