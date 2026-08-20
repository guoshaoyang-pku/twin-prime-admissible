import Sound
import lean_certs.cert_45_148

open CertVerify

/-- 不存在直径 ≤ 148 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_148 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 45) (d := 148) (c := cert_45_148) (by native_decide)
