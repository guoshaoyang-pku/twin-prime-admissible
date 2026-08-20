import Sound
import lean_certs.cert_46_148

open CertVerify

/-- 不存在直径 ≤ 148 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_148 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 46) (d := 148) (c := cert_46_148) (by native_decide)
