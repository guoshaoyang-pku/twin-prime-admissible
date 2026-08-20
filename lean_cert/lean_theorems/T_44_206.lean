import Sound
import lean_certs.cert_44_206

open CertVerify

/-- 不存在直径 ≤ 206 的可容许 44 元组 (UNSAT 证书机器验证) -/
theorem H44_gt_206 : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 44) (d := 206) (c := cert_44_206) (by native_decide)
