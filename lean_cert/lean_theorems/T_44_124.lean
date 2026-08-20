import Sound
import lean_certs.cert_44_124

open CertVerify

/-- 不存在直径 ≤ 124 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_124 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 44) (d := 124) (c := cert_44_124) (by native_decide)
