import Sound
import lean_certs.cert_46_150

open CertVerify

/-- 不存在直径 ≤ 150 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_150 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 46) (d := 150) (c := cert_46_150) (by native_decide)
