import Sound
import lean_certs.cert_44_158

open CertVerify

/-- 不存在直径 ≤ 158 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_158 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 44) (d := 158) (c := cert_44_158) (by native_decide)
