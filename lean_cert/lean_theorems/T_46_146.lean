import Sound
import lean_certs.cert_46_146

open CertVerify

/-- 不存在直径 ≤ 146 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_146 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 46) (d := 146) (c := cert_46_146) (by native_decide)
