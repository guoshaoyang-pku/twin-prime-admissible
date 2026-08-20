import Sound
import lean_certs.cert_43_120

open CertVerify

/-- 不存在直径 ≤ 120 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_120 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 43) (d := 120) (c := cert_43_120) (by native_decide)
