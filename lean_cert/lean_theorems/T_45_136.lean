import Sound
import lean_certs.cert_45_136

open CertVerify

/-- 不存在直径 ≤ 136 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_136 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 45) (d := 136) (c := cert_45_136) (by native_decide)
