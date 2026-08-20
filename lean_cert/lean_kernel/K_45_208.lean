import Sound
import lean_certs.cert_45_208

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 208 的可容许 45 元组 -/
theorem H45_gt_208_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 45) (d := 208) (c := cert_45_208) (by decide)
