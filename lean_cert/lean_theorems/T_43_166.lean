import Sound
import lean_certs.cert_43_166

open CertVerify

/-- 不存在直径 ≤ 166 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_166 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 43) (d := 166) (c := cert_43_166) (by native_decide)
