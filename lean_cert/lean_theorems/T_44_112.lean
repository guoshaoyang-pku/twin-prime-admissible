import Sound
import lean_certs.cert_44_112

open CertVerify

/-- 不存在直径 ≤ 112 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_112 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 44) (d := 112) (c := cert_44_112) (by native_decide)
