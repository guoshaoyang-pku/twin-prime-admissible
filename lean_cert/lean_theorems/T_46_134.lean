import Sound
import lean_certs.cert_46_134

open CertVerify

/-- 不存在直径 ≤ 134 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_134 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 46) (d := 134) (c := cert_46_134) (by native_decide)
