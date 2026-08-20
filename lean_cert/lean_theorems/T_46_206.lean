import Sound
import lean_certs.cert_46_206

open CertVerify

/-- 不存在直径 ≤ 206 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_206 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 46) (d := 206) (c := cert_46_206) (by native_decide)
