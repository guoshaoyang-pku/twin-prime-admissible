import Sound
import lean_certs.cert_43_92

open CertVerify

/-- 不存在直径 ≤ 92 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_92 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 43) (d := 92) (c := cert_43_92) (by native_decide)
