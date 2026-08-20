import Sound
import lean_certs.cert_44_104

open CertVerify

/-- 不存在直径 ≤ 104 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_104 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 44) (d := 104) (c := cert_44_104) (by native_decide)
