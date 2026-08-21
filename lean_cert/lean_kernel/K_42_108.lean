import Sound
import lean_certs.cert_42_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_108_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 42) (d := 108) (c := cert_42_108) (by decide)
