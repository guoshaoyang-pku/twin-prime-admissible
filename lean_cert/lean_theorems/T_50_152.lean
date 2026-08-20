import Sound
import lean_certs.cert_50_152

open CertVerify

/-- 不存在直径 ≤ 152 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_152 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 50) (d := 152) (c := cert_50_152) (by native_decide)
