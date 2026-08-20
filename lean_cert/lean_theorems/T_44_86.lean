import Sound
import lean_certs.cert_44_86

open CertVerify

/-- 不存在直径 ≤ 86 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_86 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 44) (d := 86) (c := cert_44_86) (by native_decide)
