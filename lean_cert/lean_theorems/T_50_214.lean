import Sound
import lean_certs.cert_50_214

open CertVerify

/-- 不存在直径 ≤ 214 的可容许 50 元组 (UNSAT 证书机器验证) -/
theorem H50_gt_214 : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 50) (d := 214) (c := cert_50_214) (by native_decide)
