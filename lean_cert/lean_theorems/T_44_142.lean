import Sound
import lean_certs.cert_44_142

open CertVerify

/-- 不存在直径 ≤ 142 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_142 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 44) (d := 142) (c := cert_44_142) (by native_decide)
