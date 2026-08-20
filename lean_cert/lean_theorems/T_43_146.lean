import Sound
import lean_certs.cert_43_146

open CertVerify

/-- 不存在直径 ≤ 146 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_146 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 43) (d := 146) (c := cert_43_146) (by native_decide)
