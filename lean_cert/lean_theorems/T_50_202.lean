import Sound
import lean_certs.cert_50_202

open CertVerify

/-- 不存在直径 ≤ 202 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_202 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 50) (d := 202) (c := cert_50_202) (by native_decide)
