import Sound
import lean_certs.cert_42_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_166_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 42) (d := 166) (c := cert_42_166) (by decide)
