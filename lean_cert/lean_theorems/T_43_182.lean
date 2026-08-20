import Sound
import lean_certs.cert_43_182

open CertVerify

/-- 不存在直径 ≤ 182 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_182 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 43) (d := 182) (c := cert_43_182) (by native_decide)
