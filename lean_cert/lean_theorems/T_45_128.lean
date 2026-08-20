import Sound
import lean_certs.cert_45_128

open CertVerify

/-- 不存在直径 ≤ 128 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_128 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 45) (d := 128) (c := cert_45_128) (by native_decide)
