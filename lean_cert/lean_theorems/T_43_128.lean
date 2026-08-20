import Sound
import lean_certs.cert_43_128

open CertVerify

/-- 不存在直径 ≤ 128 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_128 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 43) (d := 128) (c := cert_43_128) (by native_decide)
