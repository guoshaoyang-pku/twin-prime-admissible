import Sound
import lean_certs.cert_50_120

open CertVerify

/-- 不存在直径 ≤ 120 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_120 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 50) (d := 120) (c := cert_50_120) (by native_decide)
