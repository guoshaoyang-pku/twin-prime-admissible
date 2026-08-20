import Sound
import lean_certs.cert_50_104

open CertVerify

/-- 不存在直径 ≤ 104 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_104 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 50) (d := 104) (c := cert_50_104) (by native_decide)
