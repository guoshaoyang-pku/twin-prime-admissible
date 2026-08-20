import Sound
import lean_certs.cert_23_92

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 92 的可容许 23 元组 -/
theorem H23_gt_92_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 23) (d := 92) (c := cert_23_92) (by decide)
