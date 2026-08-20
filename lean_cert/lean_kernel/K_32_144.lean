import Sound
import lean_certs.cert_32_144

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 144 的可容许 32 元组 -/
theorem H32_gt_144_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 32) (d := 144) (c := cert_32_144) (by decide)
