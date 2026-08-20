import Sound
import lean_certs.cert_43_150

open CertVerify

/-- 不存在直径 ≤ 150 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_150 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 43) (d := 150) (c := cert_43_150) (by native_decide)
