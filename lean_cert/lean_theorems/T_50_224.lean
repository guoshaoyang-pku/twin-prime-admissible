import Sound
import lean_certs.cert_50_224

open CertVerify

/-- 不存在直径 ≤ 224 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_224 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 224 := by
  exact certValidRoot_sound (k := 50) (d := 224) (c := cert_50_224) (by native_decide)
