import Sound
import lean_certs.cert_46_214

open CertVerify

/-- 不存在直径 ≤ 214 的可容许 46 元组 (UNSAT 证书机器验证) -/
theorem H46_gt_214 : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 46) (d := 214) (c := cert_46_214) (by native_decide)
