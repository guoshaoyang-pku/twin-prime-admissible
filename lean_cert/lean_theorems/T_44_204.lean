import Sound
import lean_certs.cert_44_204

open CertVerify

/-- 不存在直径 ≤ 204 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_204 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 44) (d := 204) (c := cert_44_204) (by native_decide)
