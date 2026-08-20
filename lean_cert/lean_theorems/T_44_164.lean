import Sound
import lean_certs.cert_44_164

open CertVerify

/-- 不存在直径 ≤ 164 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_164 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 44) (d := 164) (c := cert_44_164) (by native_decide)
