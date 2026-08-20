import Sound
import lean_certs.cert_41_186

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 186 的可容许 41 元组 -/
theorem H41_gt_186_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 41) (d := 186) (c := cert_41_186) (by decide)
