import Sound
import lean_certs.cert_46_186

open CertVerify

/-- 不存在直径 ≤ 186 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_186 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 46) (d := 186) (c := cert_46_186) (by native_decide)
