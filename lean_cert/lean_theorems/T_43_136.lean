import Sound
import lean_certs.cert_43_136

open CertVerify

/-- 不存在直径 ≤ 136 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_136 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 43) (d := 136) (c := cert_43_136) (by native_decide)
