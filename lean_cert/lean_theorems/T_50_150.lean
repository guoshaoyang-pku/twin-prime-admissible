import Sound
import lean_certs.cert_50_150

open CertVerify

/-- 不存在直径 ≤ 150 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_150 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 50) (d := 150) (c := cert_50_150) (by native_decide)
