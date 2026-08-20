import Sound
import lean_certs.cert_44_148

open CertVerify

/-- 不存在直径 ≤ 148 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_148 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 44) (d := 148) (c := cert_44_148) (by native_decide)
