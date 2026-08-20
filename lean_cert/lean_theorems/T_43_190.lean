import Sound
import lean_certs.cert_43_190

open CertVerify

/-- 不存在直径 ≤ 190 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_190 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 43) (d := 190) (c := cert_43_190) (by native_decide)
