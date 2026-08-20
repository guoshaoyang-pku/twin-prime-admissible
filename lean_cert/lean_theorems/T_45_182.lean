import Sound
import lean_certs.cert_45_182

open CertVerify

/-- 不存在直径 ≤ 182 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_182 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 45) (d := 182) (c := cert_45_182) (by native_decide)
