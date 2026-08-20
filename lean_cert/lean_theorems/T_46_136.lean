import Sound
import lean_certs.cert_46_136

open CertVerify

/-- 不存在直径 ≤ 136 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_136 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 46) (d := 136) (c := cert_46_136) (by native_decide)
