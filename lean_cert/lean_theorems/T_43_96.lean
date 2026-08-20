import Sound
import lean_certs.cert_43_96

open CertVerify

/-- 不存在直径 ≤ 96 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_96 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 43) (d := 96) (c := cert_43_96) (by native_decide)
