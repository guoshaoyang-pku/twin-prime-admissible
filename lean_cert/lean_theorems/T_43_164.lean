import Sound
import lean_certs.cert_43_164

open CertVerify

/-- 不存在直径 ≤ 164 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_164 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 43) (d := 164) (c := cert_43_164) (by native_decide)
