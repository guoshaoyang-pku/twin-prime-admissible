import Sound
import lean_certs.cert_46_162

open CertVerify

/-- 不存在直径 ≤ 162 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_162 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 46) (d := 162) (c := cert_46_162) (by native_decide)
