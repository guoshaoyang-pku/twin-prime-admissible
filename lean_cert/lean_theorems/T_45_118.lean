import Sound
import lean_certs.cert_45_118

open CertVerify

/-- 不存在直径 ≤ 118 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_118 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 45) (d := 118) (c := cert_45_118) (by native_decide)
