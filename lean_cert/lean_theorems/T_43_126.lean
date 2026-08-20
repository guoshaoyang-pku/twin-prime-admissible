import Sound
import lean_certs.cert_43_126

open CertVerify

/-- 不存在直径 ≤ 126 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_126 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 43) (d := 126) (c := cert_43_126) (by native_decide)
