import Sound
import lean_certs.cert_46_166

open CertVerify

/-- 不存在直径 ≤ 166 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_166 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 46) (d := 166) (c := cert_46_166) (by native_decide)
