import Sound
import lean_certs.cert_46_142

open CertVerify

/-- 不存在直径 ≤ 142 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_142 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 46) (d := 142) (c := cert_46_142) (by native_decide)
