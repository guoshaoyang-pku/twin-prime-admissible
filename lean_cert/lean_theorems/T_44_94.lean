import Sound
import lean_certs.cert_44_94

open CertVerify

/-- 不存在直径 ≤ 94 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_94 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 44) (d := 94) (c := cert_44_94) (by native_decide)
