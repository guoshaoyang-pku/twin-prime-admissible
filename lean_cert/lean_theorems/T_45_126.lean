import Sound
import lean_certs.cert_45_126

open CertVerify

/-- 不存在直径 ≤ 126 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_126 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 45) (d := 126) (c := cert_45_126) (by native_decide)
