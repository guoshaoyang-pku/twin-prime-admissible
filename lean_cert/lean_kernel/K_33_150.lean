import Sound
import lean_certs.cert_33_150

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 150 的可容许 33 元组 -/
theorem H33_gt_150_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 33) (d := 150) (c := cert_33_150) (by decide)
