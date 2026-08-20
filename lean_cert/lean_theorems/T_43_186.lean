import Sound
import lean_certs.cert_43_186

open CertVerify

/-- 不存在直径 ≤ 186 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_186 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 43) (d := 186) (c := cert_43_186) (by native_decide)
