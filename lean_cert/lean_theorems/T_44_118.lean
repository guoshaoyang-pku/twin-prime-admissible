import Sound
import lean_certs.cert_44_118

open CertVerify

/-- 不存在直径 ≤ 118 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_118 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 44) (d := 118) (c := cert_44_118) (by native_decide)
