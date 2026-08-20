import Sound
import lean_certs.cert_44_192

open CertVerify

/-- 不存在直径 ≤ 192 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_192 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 44) (d := 192) (c := cert_44_192) (by native_decide)
