import Sound
import lean_certs.cert_43_104

open CertVerify

/-- 不存在直径 ≤ 104 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_104 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 43) (d := 104) (c := cert_43_104) (by native_decide)
