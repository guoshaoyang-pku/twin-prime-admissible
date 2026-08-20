import Sound
import lean_certs.cert_44_180

open CertVerify

/-- 不存在直径 ≤ 180 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_180 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 44) (d := 180) (c := cert_44_180) (by native_decide)
