import Sound
import lean_certs.cert_45_210

open CertVerify

/-- 不存在直径 ≤ 210 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_210 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 45) (d := 210) (c := cert_45_210) (by native_decide)
