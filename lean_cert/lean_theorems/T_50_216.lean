import Sound
import lean_certs.cert_50_216

open CertVerify

/-- 不存在直径 ≤ 216 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_216 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 216 := by
  exact certValidRoot_sound (k := 50) (d := 216) (c := cert_50_216) (by native_decide)
