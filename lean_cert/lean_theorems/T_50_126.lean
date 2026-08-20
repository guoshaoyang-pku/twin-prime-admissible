import Sound
import lean_certs.cert_50_126

open CertVerify

/-- 不存在直径 ≤ 126 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_126 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 50) (d := 126) (c := cert_50_126) (by native_decide)
