import Sound
import lean_certs.cert_45_104

open CertVerify

/-- 不存在直径 ≤ 104 的可容许 45 元组 (UNSAT 证书机器验证) -/
theorem H45_gt_104 : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 45) (d := 104) (c := cert_45_104) (by native_decide)
