import Sound
import lean_certs.cert_46_200

open CertVerify

/-- 不存在直径 ≤ 200 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_200 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 46) (d := 200) (c := cert_46_200) (by native_decide)
