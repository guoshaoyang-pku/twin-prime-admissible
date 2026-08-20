import Sound
import lean_certs.cert_46_126

open CertVerify

/-- 不存在直径 ≤ 126 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_126 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 46) (d := 126) (c := cert_46_126) (by native_decide)
