import Sound
import lean_certs.cert_26_112

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 112 的可容许 26 元组 -/
theorem H26_gt_112_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 26) (d := 112) (c := cert_26_112) (by decide)
