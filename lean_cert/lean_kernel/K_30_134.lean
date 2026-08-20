import Sound
import lean_certs.cert_30_134

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 134 的可容许 30 元组 -/
theorem H30_gt_134_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 30) (d := 134) (c := cert_30_134) (by decide)
