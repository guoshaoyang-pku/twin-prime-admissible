import Sound
import lean_certs.cert_44_128

open CertVerify

/-- 不存在直径 ≤ 128 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_128 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 44) (d := 128) (c := cert_44_128) (by native_decide)
