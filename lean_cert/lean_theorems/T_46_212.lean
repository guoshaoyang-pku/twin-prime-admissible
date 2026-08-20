import Sound
import lean_certs.cert_46_212

open CertVerify

/-- 不存在直径 ≤ 212 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_212 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 46) (d := 212) (c := cert_46_212) (by native_decide)
