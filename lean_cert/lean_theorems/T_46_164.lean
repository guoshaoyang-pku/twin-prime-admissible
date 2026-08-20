import Sound
import lean_certs.cert_46_164

open CertVerify

/-- 不存在直径 ≤ 164 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_164 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 46) (d := 164) (c := cert_46_164) (by native_decide)
