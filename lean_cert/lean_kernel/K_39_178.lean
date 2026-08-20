import Sound
import lean_certs.cert_39_178

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 178 的可容许 39 元组 -/
theorem H39_gt_178_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 39) (d := 178) (c := cert_39_178) (by decide)
