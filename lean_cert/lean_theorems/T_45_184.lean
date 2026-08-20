import Sound
import lean_certs.cert_45_184

open CertVerify

/-- 不存在直径 ≤ 184 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_184 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 45) (d := 184) (c := cert_45_184) (by native_decide)
