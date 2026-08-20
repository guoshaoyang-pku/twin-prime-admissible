import Sound
import lean_certs.cert_38_174

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 174 的可容许 38 元组 -/
theorem H38_gt_174_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 38) (d := 174) (c := cert_38_174) (by decide)
