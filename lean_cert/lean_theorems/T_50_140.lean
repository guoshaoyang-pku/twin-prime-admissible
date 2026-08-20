import Sound
import lean_certs.cert_50_140

open CertVerify

/-- 不存在直径 ≤ 140 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_140 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 50) (d := 140) (c := cert_50_140) (by native_decide)
