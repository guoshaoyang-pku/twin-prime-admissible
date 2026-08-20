import Sound
import lean_certs.cert_46_110

open CertVerify

/-- 不存在直径 ≤ 110 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_110 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 46) (d := 110) (c := cert_46_110) (by native_decide)
