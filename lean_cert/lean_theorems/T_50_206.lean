import Sound
import lean_certs.cert_50_206

open CertVerify

/-- 不存在直径 ≤ 206 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_206 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 50) (d := 206) (c := cert_50_206) (by native_decide)
