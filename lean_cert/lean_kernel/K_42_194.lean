import Sound
import lean_certs.cert_42_194

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 194 的可容许 42 元组 -/
theorem H42_gt_194_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 42) (d := 194) (c := cert_42_194) (by decide)
