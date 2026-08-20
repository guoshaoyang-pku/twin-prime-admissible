import Sound
import lean_certs.cert_45_208

open CertVerify

/-- 不存在直径 ≤ 208 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_208 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 45) (d := 208) (c := cert_45_208) (by native_decide)
