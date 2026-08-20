import Sound
import lean_certs.cert_44_146

open CertVerify

/-- 不存在直径 ≤ 146 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_146 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 44) (d := 146) (c := cert_44_146) (by native_decide)
