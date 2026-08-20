import Sound
import lean_certs.cert_50_112

open CertVerify

/-- 不存在直径 ≤ 112 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_112 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 50) (d := 112) (c := cert_50_112) (by native_decide)
