import Sound
import lean_certs.cert_44_152

open CertVerify

/-- 不存在直径 ≤ 152 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_152 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 44) (d := 152) (c := cert_44_152) (by native_decide)
