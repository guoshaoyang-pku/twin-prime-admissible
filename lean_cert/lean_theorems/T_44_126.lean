import Sound
import lean_certs.cert_44_126

open CertVerify

/-- 不存在直径 ≤ 126 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_126 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 44) (d := 126) (c := cert_44_126) (by native_decide)
