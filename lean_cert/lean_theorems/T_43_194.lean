import Sound
import lean_certs.cert_43_194

open CertVerify

/-- 不存在直径 ≤ 194 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_194 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 43) (d := 194) (c := cert_43_194) (by native_decide)
