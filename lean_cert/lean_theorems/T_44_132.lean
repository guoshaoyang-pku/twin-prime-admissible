import Sound
import lean_certs.cert_44_132

open CertVerify

/-- 不存在直径 ≤ 132 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_132 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 44) (d := 132) (c := cert_44_132) (by native_decide)
