import Sound
import lean_certs.cert_44_88

open CertVerify

/-- 不存在直径 ≤ 88 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_88 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 44) (d := 88) (c := cert_44_88) (by native_decide)
