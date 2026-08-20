import Sound
import lean_certs.cert_50_194

open CertVerify

/-- 不存在直径 ≤ 194 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_194 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 50) (d := 194) (c := cert_50_194) (by native_decide)
