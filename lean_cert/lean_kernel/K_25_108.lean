import Sound
import lean_certs.cert_25_108

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 108 的可容许 25 元组 -/
theorem H25_gt_108_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 25) (d := 108) (c := cert_25_108) (by decide)
