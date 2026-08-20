import Sound
import lean_certs.cert_45_112

open CertVerify

/-- 不存在直径 ≤ 112 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_112 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 45) (d := 112) (c := cert_45_112) (by native_decide)
