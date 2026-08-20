import Sound
import lean_certs.cert_44_200

open CertVerify

/-- 不存在直径 ≤ 200 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_200 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 44) (d := 200) (c := cert_44_200) (by native_decide)
