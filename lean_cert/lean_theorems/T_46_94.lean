import Sound
import lean_certs.cert_46_94

open CertVerify

/-- 不存在直径 ≤ 94 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_94 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 46) (d := 94) (c := cert_46_94) (by native_decide)
