import Sound
import lean_certs.cert_43_198

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 198 的可容许 43 元组 -/
theorem H43_gt_198_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 43) (d := 198) (c := cert_43_198) (by decide)
