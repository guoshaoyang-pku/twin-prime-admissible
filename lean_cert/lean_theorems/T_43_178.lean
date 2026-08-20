import Sound
import lean_certs.cert_43_178

open CertVerify

/-- 不存在直径 ≤ 178 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_178 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 43) (d := 178) (c := cert_43_178) (by native_decide)
