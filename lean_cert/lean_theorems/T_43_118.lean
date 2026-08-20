import Sound
import lean_certs.cert_43_118

open CertVerify

/-- 不存在直径 ≤ 118 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_118 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 43) (d := 118) (c := cert_43_118) (by native_decide)
