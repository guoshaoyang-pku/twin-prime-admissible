import Sound
import lean_certs.cert_44_168

open CertVerify

/-- 不存在直径 ≤ 168 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_168 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 44) (d := 168) (c := cert_44_168) (by native_decide)
