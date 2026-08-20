import Sound
import lean_certs.cert_46_202

open CertVerify

/-- 不存在直径 ≤ 202 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_202 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 46) (d := 202) (c := cert_46_202) (by native_decide)
