import Sound
import lean_certs.cert_45_194

open CertVerify

/-- 不存在直径 ≤ 194 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_194 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 45) (d := 194) (c := cert_45_194) (by native_decide)
