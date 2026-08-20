import Sound
import lean_certs.cert_46_140

open CertVerify

/-- 不存在直径 ≤ 140 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_140 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 46) (d := 140) (c := cert_46_140) (by native_decide)
