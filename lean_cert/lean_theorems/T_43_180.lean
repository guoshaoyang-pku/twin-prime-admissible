import Sound
import lean_certs.cert_43_180

open CertVerify

/-- 不存在直径 ≤ 180 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_180 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 43) (d := 180) (c := cert_43_180) (by native_decide)
