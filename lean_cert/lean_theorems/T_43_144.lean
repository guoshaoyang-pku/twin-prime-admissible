import Sound
import lean_certs.cert_43_144

open CertVerify

/-- 不存在直径 ≤ 144 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_144 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 43) (d := 144) (c := cert_43_144) (by native_decide)
