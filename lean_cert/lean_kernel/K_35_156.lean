import Sound
import lean_certs.cert_35_156

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 156 的可容许 35 元组 -/
theorem H35_gt_156_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 35) (d := 156) (c := cert_35_156) (by decide)
