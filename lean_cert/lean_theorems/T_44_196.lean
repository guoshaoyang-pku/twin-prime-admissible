import Sound
import lean_certs.cert_44_196

open CertVerify

/-- 不存在直径 ≤ 196 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_196 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 44) (d := 196) (c := cert_44_196) (by native_decide)
