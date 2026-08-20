import Sound
import lean_certs.cert_43_140

open CertVerify

/-- 不存在直径 ≤ 140 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_140 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 43) (d := 140) (c := cert_43_140) (by native_decide)
