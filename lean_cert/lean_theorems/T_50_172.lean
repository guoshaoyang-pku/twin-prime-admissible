import Sound
import lean_certs.cert_50_172

open CertVerify

/-- 不存在直径 ≤ 172 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_172 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 50) (d := 172) (c := cert_50_172) (by native_decide)
