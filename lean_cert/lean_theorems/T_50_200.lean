import Sound
import lean_certs.cert_50_200

open CertVerify

/-- 不存在直径 ≤ 200 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_200 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 50) (d := 200) (c := cert_50_200) (by native_decide)
