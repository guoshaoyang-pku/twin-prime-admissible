import Sound
import lean_certs.cert_44_96

open CertVerify

/-- 不存在直径 ≤ 96 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_96 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 44) (d := 96) (c := cert_44_96) (by native_decide)
