import Sound
import lean_certs.cert_44_194

open CertVerify

/-- 不存在直径 ≤ 194 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_194 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 44) (d := 194) (c := cert_44_194) (by native_decide)
