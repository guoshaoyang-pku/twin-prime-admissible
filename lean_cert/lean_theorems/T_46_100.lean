import Sound
import lean_certs.cert_46_100

open CertVerify

/-- 不存在直径 ≤ 100 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_100 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 46) (d := 100) (c := cert_46_100) (by native_decide)
