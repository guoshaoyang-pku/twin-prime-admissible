import Sound
import lean_certs.cert_45_94

open CertVerify

/-- 不存在直径 ≤ 94 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_94 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 45) (d := 94) (c := cert_45_94) (by native_decide)
