import Sound
import lean_certs.cert_44_204

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 204 的可容许 44 元组 -/
theorem H44_gt_204_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 44) (d := 204) (c := cert_44_204) (by decide)
