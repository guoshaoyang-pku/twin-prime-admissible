import Sound
import lean_certs.cert_49_226

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 226 的可容许 49 元组 -/
theorem H49_gt_226_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 226 := by
  exact certValidRoot_sound (k := 49) (d := 226) (c := cert_49_226) (by decide)
