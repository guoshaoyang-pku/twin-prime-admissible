import Sound
import lean_certs.cert_40_184

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 184 的可容许 40 元组 -/
theorem H40_gt_184_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 40) (d := 184) (c := cert_40_184) (by decide)
