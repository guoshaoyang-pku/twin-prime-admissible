import Sound
import lean_certs.cert_43_152

open CertVerify

/-- 不存在直径 ≤ 152 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_152 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 43) (d := 152) (c := cert_43_152) (by native_decide)
