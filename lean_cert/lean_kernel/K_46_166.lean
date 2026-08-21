import Sound
import lean_certs.cert_46_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_166_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 46) (d := 166) (c := cert_46_166) (by decide)
