import Sound
import lean_certs.cert_45_166

open CertVerify

/-- 不存在直径 ≤ 166 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_166 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 45) (d := 166) (c := cert_45_166) (by native_decide)
