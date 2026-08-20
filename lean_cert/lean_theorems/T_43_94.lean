import Sound
import lean_certs.cert_43_94

open CertVerify

/-- 不存在直径 ≤ 94 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_94 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 43) (d := 94) (c := cert_43_94) (by native_decide)
