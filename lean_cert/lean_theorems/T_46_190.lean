import Sound
import lean_certs.cert_46_190

open CertVerify

/-- 不存在直径 ≤ 190 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_190 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 46) (d := 190) (c := cert_46_190) (by native_decide)
