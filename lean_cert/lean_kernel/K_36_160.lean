import Sound
import lean_certs.cert_36_160

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 160 的可容许 36 元组 -/
theorem H36_gt_160_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 36) (d := 160) (c := cert_36_160) (by decide)
