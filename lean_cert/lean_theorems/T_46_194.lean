import Sound
import lean_certs.cert_46_194

open CertVerify

/-- 不存在直径 ≤ 194 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_194 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 46) (d := 194) (c := cert_46_194) (by native_decide)
