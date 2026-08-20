import Sound
import lean_certs.cert_46_178

open CertVerify

/-- 不存在直径 ≤ 178 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_178 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 46) (d := 178) (c := cert_46_178) (by native_decide)
