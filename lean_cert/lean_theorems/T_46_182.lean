import Sound
import lean_certs.cert_46_182

open CertVerify

/-- 不存在直径 ≤ 182 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_182 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 46) (d := 182) (c := cert_46_182) (by native_decide)
