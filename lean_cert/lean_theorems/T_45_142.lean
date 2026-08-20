import Sound
import lean_certs.cert_45_142

open CertVerify

/-- 不存在直径 ≤ 142 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_142 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 45) (d := 142) (c := cert_45_142) (by native_decide)
