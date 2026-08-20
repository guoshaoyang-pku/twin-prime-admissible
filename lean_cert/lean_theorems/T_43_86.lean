import Sound
import lean_certs.cert_43_86

open CertVerify

/-- 不存在直径 ≤ 86 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_86 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 43) (d := 86) (c := cert_43_86) (by native_decide)
