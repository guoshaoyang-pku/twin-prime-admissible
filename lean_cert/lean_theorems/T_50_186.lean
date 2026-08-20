import Sound
import lean_certs.cert_50_186

open CertVerify

/-- 不存在直径 ≤ 186 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_186 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 50) (d := 186) (c := cert_50_186) (by native_decide)
