import Sound
import lean_certs.cert_45_186

open CertVerify

/-- 不存在直径 ≤ 186 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_186 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 45) (d := 186) (c := cert_45_186) (by native_decide)
