import Sound
import lean_certs.cert_44_166

open CertVerify

/-- 不存在直径 ≤ 166 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_166 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 44) (d := 166) (c := cert_44_166) (by native_decide)
