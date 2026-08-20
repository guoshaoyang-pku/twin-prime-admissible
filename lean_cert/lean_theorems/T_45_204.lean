import Sound
import lean_certs.cert_45_204

open CertVerify

/-- 不存在直径 ≤ 204 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_204 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 45) (d := 204) (c := cert_45_204) (by native_decide)
