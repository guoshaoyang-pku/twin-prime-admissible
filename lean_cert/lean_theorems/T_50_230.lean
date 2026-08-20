import Sound
import lean_certs.cert_50_230

open CertVerify

/-- 不存在直径 ≤ 230 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_230 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 230 := by
  exact certValidRoot_sound (k := 50) (d := 230) (c := cert_50_230) (by native_decide)
