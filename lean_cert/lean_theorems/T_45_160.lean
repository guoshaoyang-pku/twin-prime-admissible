import Sound
import lean_certs.cert_45_160

open CertVerify

/-- 不存在直径 ≤ 160 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_160 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 45) (d := 160) (c := cert_45_160) (by native_decide)
