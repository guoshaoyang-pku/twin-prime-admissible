import Sound
import lean_certs.cert_46_212

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 212 的可容许 46 元组 -/
theorem H46_gt_212_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 46) (d := 212) (c := cert_46_212) (by decide)
