import Sound
import lean_certs.cert_50_100

open CertVerify

/-- 不存在直径 ≤ 100 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_100 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 50) (d := 100) (c := cert_50_100) (by native_decide)
