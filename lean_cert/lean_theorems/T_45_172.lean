import Sound
import lean_certs.cert_45_172

open CertVerify

/-- 不存在直径 ≤ 172 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_172 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 45) (d := 172) (c := cert_45_172) (by native_decide)
