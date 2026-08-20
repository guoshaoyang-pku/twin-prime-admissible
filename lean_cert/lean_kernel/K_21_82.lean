import Sound
import lean_certs.cert_21_82

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 82 的可容许 21 元组 -/
theorem H21_gt_82_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 21) (d := 82) (c := cert_21_82) (by decide)
