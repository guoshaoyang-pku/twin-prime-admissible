import Sound
import lean_certs.cert_34_154

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 154 的可容许 34 元组 -/
theorem H34_gt_154_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 34) (d := 154) (c := cert_34_154) (by decide)
