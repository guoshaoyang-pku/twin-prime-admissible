import Sound
import lean_certs.cert_24_98

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 98 的可容许 24 元组 -/
theorem H24_gt_98_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 24) (d := 98) (c := cert_24_98) (by decide)
