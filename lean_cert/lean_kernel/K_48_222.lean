import Sound
import lean_certs.cert_48_222

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 222 的可容许 48 元组 -/
theorem H48_gt_222_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 222 := by
  exact certValidRoot_sound (k := 48) (d := 222) (c := cert_48_222) (by decide)
