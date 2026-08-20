import Sound
import lean_certs.cert_46_160

open CertVerify

/-- 不存在直径 ≤ 160 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_160 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 46) (d := 160) (c := cert_46_160) (by native_decide)
