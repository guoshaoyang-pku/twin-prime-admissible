import Sound
import lean_certs.cert_46_192

open CertVerify

/-- 不存在直径 ≤ 192 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_192 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 46) (d := 192) (c := cert_46_192) (by native_decide)
