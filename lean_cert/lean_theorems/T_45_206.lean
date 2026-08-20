import Sound
import lean_certs.cert_45_206

open CertVerify

/-- 不存在直径 ≤ 206 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_206 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 45) (d := 206) (c := cert_45_206) (by native_decide)
