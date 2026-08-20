import Sound
import lean_certs.cert_46_120

open CertVerify

/-- 不存在直径 ≤ 120 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_120 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 46) (d := 120) (c := cert_46_120) (by native_decide)
