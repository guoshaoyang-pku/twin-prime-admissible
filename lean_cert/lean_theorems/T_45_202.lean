import Sound
import lean_certs.cert_45_202

open CertVerify

/-- 不存在直径 ≤ 202 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_202 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 45) (d := 202) (c := cert_45_202) (by native_decide)
