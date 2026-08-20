import Sound
import lean_certs.cert_45_92

open CertVerify

/-- 不存在直径 ≤ 92 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_92 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 45) (d := 92) (c := cert_45_92) (by native_decide)
