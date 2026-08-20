import Sound
import lean_certs.cert_46_104

open CertVerify

/-- 不存在直径 ≤ 104 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_104 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 46) (d := 104) (c := cert_46_104) (by native_decide)
