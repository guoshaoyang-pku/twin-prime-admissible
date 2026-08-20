import Sound
import lean_certs.cert_50_136

open CertVerify

/-- 不存在直径 ≤ 136 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_136 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 50) (d := 136) (c := cert_50_136) (by native_decide)
