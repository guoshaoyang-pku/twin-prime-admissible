import Sound
import lean_certs.cert_50_182

open CertVerify

/-- 不存在直径 ≤ 182 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_182 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 50) (d := 182) (c := cert_50_182) (by native_decide)
