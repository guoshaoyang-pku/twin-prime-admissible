import Sound
import lean_certs.cert_50_232

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 232 的可容许 50 元组 -/
theorem H50_gt_232_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 232 := by
  exact certValidRoot_sound (k := 50) (d := 232) (c := cert_50_232) (by decide)
