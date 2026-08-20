import Sound
import lean_certs.cert_50_164

open CertVerify

/-- 不存在直径 ≤ 164 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_164 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 50) (d := 164) (c := cert_50_164) (by native_decide)
