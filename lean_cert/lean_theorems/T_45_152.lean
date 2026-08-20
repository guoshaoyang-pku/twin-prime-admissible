import Sound
import lean_certs.cert_45_152

open CertVerify

/-- 不存在直径 ≤ 152 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_152 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 45) (d := 152) (c := cert_45_152) (by native_decide)
