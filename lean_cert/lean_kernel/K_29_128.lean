import Sound
import lean_certs.cert_29_128

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 128 的可容许 29 元组 -/
theorem H29_gt_128_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 29) (d := 128) (c := cert_29_128) (by decide)
