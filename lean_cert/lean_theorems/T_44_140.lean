import Sound
import lean_certs.cert_44_140

open CertVerify

/-- 不存在直径 ≤ 140 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_140 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 44) (d := 140) (c := cert_44_140) (by native_decide)
