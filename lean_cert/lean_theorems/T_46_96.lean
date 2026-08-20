import Sound
import lean_certs.cert_46_96

open CertVerify

/-- 不存在直径 ≤ 96 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_96 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 46) (d := 96) (c := cert_46_96) (by native_decide)
