import Sound
import lean_certs.cert_50_128

open CertVerify

/-- 不存在直径 ≤ 128 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_128 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 50) (d := 128) (c := cert_50_128) (by native_decide)
