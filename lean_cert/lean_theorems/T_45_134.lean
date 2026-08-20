import Sound
import lean_certs.cert_45_134

open CertVerify

/-- 不存在直径 ≤ 134 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_134 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 45) (d := 134) (c := cert_45_134) (by native_decide)
