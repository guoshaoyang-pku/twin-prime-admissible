import Sound
import lean_certs.cert_46_196

open CertVerify

/-- 不存在直径 ≤ 196 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_196 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 46) (d := 196) (c := cert_46_196) (by native_decide)
