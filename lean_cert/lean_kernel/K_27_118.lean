import Sound
import lean_certs.cert_27_118

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 118 的可容许 27 元组 -/
theorem H27_gt_118_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 27) (d := 118) (c := cert_27_118) (by decide)
