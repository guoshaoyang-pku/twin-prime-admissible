import Sound
import lean_certs.cert_42_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_140_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 42) (d := 140) (c := cert_42_140) (by decide)
