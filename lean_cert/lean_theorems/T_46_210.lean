import Sound
import lean_certs.cert_46_210

open CertVerify

/-- 不存在直径 ≤ 210 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_210 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 46) (d := 210) (c := cert_46_210) (by native_decide)
