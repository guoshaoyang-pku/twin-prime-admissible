import Sound
import lean_certs.cert_46_92

open CertVerify

/-- 不存在直径 ≤ 92 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_92 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 46) (d := 92) (c := cert_46_92) (by native_decide)
