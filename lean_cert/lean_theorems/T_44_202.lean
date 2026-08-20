import Sound
import lean_certs.cert_44_202

open CertVerify

/-- 不存在直径 ≤ 202 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_202 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 44) (d := 202) (c := cert_44_202) (by native_decide)
