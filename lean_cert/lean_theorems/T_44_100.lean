import Sound
import lean_certs.cert_44_100

open CertVerify

/-- 不存在直径 ≤ 100 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_100 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 44) (d := 100) (c := cert_44_100) (by native_decide)
