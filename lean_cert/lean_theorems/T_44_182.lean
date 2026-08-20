import Sound
import lean_certs.cert_44_182

open CertVerify

/-- 不存在直径 ≤ 182 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_182 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 44) (d := 182) (c := cert_44_182) (by native_decide)
