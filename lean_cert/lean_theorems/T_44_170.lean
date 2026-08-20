import Sound
import lean_certs.cert_44_170

open CertVerify

/-- 不存在直径 ≤ 170 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_170 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 44) (d := 170) (c := cert_44_170) (by native_decide)
