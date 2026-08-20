import Sound
import lean_certs.cert_22_88

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 88 的可容许 22 元组 -/
theorem H22_gt_88_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 22) (d := 88) (c := cert_22_88) (by decide)
