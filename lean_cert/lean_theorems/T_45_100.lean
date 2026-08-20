import Sound
import lean_certs.cert_45_100

open CertVerify

/-- 不存在直径 ≤ 100 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_100 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 45) (d := 100) (c := cert_45_100) (by native_decide)
