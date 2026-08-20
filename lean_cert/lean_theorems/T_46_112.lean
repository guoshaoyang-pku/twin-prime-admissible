import Sound
import lean_certs.cert_46_112

open CertVerify

/-- 不存在直径 ≤ 112 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_112 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 46) (d := 112) (c := cert_46_112) (by native_decide)
