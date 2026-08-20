import Sound
import lean_certs.cert_44_178

open CertVerify

/-- 不存在直径 ≤ 178 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_178 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 44) (d := 178) (c := cert_44_178) (by native_decide)
