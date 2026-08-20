import Sound
import lean_certs.cert_37_166

open CertVerify

set_option maxHeartbeats 8000000 in
/-- 纯内核 decide 版本 (无 native_decide): 不存在直径 ≤ 166 的可容许 37 元组 -/
theorem H37_gt_166_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 37) (d := 166) (c := cert_37_166) (by decide)
