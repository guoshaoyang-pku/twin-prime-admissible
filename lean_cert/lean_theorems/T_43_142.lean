import Sound
import lean_certs.cert_43_142

open CertVerify

/-- 不存在直径 ≤ 142 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_142 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 43) (d := 142) (c := cert_43_142) (by native_decide)
