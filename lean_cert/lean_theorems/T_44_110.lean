import Sound
import lean_certs.cert_44_110

open CertVerify

/-- 不存在直径 ≤ 110 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_110 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 44) (d := 110) (c := cert_44_110) (by native_decide)
