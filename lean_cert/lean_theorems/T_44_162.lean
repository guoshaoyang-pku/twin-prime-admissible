import Sound
import lean_certs.cert_44_162

open CertVerify

/-- 不存在直径 ≤ 162 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_162 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 44) (d := 162) (c := cert_44_162) (by native_decide)
