import Sound
import lean_certs.cert_42_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_84_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 42) (d := 84) (c := cert_42_84) (by decide)
