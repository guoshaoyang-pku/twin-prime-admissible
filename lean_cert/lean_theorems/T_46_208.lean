import Sound
import lean_certs.cert_46_208

open CertVerify

/-- 不存在直径 ≤ 208 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_208 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 46) (d := 208) (c := cert_46_208) (by native_decide)
