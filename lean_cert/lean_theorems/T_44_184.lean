import Sound
import lean_certs.cert_44_184

open CertVerify

/-- 不存在直径 ≤ 184 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_184 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 44) (d := 184) (c := cert_44_184) (by native_decide)
