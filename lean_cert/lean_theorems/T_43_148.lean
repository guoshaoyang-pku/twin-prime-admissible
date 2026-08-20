import Sound
import lean_certs.cert_43_148

open CertVerify

/-- 不存在直径 ≤ 148 的可容许 43 元组 (UNSAT 证书机器验证) -/
theorem H43_gt_148 : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 43) (d := 148) (c := cert_43_148) (by native_decide)
