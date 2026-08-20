import Sound
import lean_certs.cert_50_196

open CertVerify

/-- 不存在直径 ≤ 196 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_196 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 50) (d := 196) (c := cert_50_196) (by native_decide)
