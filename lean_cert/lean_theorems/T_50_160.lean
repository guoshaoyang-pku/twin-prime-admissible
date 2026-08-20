import Sound
import lean_certs.cert_50_160

open CertVerify

/-- 不存在直径 ≤ 160 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_160 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 50) (d := 160) (c := cert_50_160) (by native_decide)
