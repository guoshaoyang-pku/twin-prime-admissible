import Sound
import lean_certs.cert_46_152

open CertVerify

/-- 不存在直径 ≤ 152 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_152 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 46) (d := 152) (c := cert_46_152) (by native_decide)
