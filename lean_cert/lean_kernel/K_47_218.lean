import Sound
import lean_certs.cert_47_218

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 218 的可容许 47 元组 -/
theorem H47_gt_218_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 218 := by
  exact certValidRoot_sound (k := 47) (d := 218) (c := cert_47_218) (by decide)
