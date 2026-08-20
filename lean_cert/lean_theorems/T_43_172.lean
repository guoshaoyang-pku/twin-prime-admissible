import Sound
import lean_certs.cert_43_172

open CertVerify

/-- 不存在直径 ≤ 172 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_172 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 43) (d := 172) (c := cert_43_172) (by native_decide)
