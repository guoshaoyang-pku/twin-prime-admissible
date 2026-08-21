import Sound
import lean_certs.cert_42_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_176_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 42) (d := 176) (c := cert_42_176) (by decide)
