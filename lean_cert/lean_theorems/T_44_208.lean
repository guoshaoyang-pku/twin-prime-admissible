import Sound
import lean_certs.cert_44_208

open CertVerify

/-- 不存在直径 ≤ 208 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_208 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 44) (d := 208) (c := cert_44_208) (by native_decide)
