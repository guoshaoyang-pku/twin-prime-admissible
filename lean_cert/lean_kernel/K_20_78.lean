import Sound
import lean_certs.cert_20_78

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 78 的可容许 20 元组 -/
theorem H20_gt_78_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 20) (d := 78) (c := cert_20_78) (by decide)
