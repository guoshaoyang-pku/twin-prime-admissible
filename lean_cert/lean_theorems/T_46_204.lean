import Sound
import lean_certs.cert_46_204

open CertVerify

/-- 不存在直径 ≤ 204 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_204 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 46) (d := 204) (c := cert_46_204) (by native_decide)
