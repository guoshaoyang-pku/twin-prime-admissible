import Sound
import lean_certs.cert_43_112

open CertVerify

/-- 不存在直径 ≤ 112 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_112 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 43) (d := 112) (c := cert_43_112) (by native_decide)
