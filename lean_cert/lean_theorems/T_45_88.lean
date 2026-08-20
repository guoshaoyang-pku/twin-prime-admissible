import Sound
import lean_certs.cert_45_88

open CertVerify

/-- 不存在直径 ≤ 88 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_88 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 45) (d := 88) (c := cert_45_88) (by native_decide)
