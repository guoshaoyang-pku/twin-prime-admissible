import Sound
import lean_certs.cert_45_150

open CertVerify

/-- 不存在直径 ≤ 150 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_150 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 45) (d := 150) (c := cert_45_150) (by native_decide)
