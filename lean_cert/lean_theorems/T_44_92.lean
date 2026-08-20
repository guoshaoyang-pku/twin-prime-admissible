import Sound
import lean_certs.cert_44_92

open CertVerify

/-- 不存在直径 ≤ 92 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_92 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 44) (d := 92) (c := cert_44_92) (by native_decide)
