import Sound
import lean_certs.cert_46_180

open CertVerify

/-- 不存在直径 ≤ 180 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_180 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 46) (d := 180) (c := cert_46_180) (by native_decide)
