import Sound
import lean_certs.cert_31_138

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 138 的可容许 31 元组 -/
theorem H31_gt_138_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 31) (d := 138) (c := cert_31_138) (by decide)
