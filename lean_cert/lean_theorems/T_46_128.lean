import Sound
import lean_certs.cert_46_128

open CertVerify

/-- 不存在直径 ≤ 128 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_128 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 46) (d := 128) (c := cert_46_128) (by native_decide)
