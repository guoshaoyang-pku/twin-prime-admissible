import Sound
import lean_certs.cert_44_176

open CertVerify

/-- 不存在直径 ≤ 176 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_176 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 44) (d := 176) (c := cert_44_176) (by native_decide)
