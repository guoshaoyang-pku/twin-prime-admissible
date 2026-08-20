import Sound
import lean_certs.cert_43_160

open CertVerify

/-- 不存在直径 ≤ 160 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_160 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 43) (d := 160) (c := cert_43_160) (by native_decide)
