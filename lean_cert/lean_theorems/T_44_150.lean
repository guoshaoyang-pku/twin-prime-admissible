import Sound
import lean_certs.cert_44_150

open CertVerify

/-- 不存在直径 ≤ 150 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_150 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 44) (d := 150) (c := cert_44_150) (by native_decide)
