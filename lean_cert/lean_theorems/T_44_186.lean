import Sound
import lean_certs.cert_44_186

open CertVerify

/-- 不存在直径 ≤ 186 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_186 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 44) (d := 186) (c := cert_44_186) (by native_decide)
