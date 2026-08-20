import Sound
import lean_certs.cert_44_172

open CertVerify

/-- 不存在直径 ≤ 172 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_172 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 44) (d := 172) (c := cert_44_172) (by native_decide)
