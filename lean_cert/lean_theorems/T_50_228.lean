import Sound
import lean_certs.cert_50_228

open CertVerify

/-- 不存在直径 ≤ 228 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_228 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 228 := by
  exact certValidRoot_sound (k := 50) (d := 228) (c := cert_50_228) (by native_decide)
