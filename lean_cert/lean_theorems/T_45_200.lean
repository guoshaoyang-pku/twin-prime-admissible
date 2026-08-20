import Sound
import lean_certs.cert_45_200

open CertVerify

/-- 不存在直径 ≤ 200 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_200 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 45) (d := 200) (c := cert_45_200) (by native_decide)
