import Sound
import lean_certs.cert_28_124

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 124 的可容许 28 元组 -/
theorem H28_gt_124_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 28) (d := 124) (c := cert_28_124) (by decide)
