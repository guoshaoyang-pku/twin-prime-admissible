import Sound
import lean_certs.cert_43_184

open CertVerify

/-- 不存在直径 ≤ 184 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_184 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 43) (d := 184) (c := cert_43_184) (by native_decide)
