import Sound
import lean_certs.cert_29_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_84_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 29) (d := 84) (c := cert_29_84) (by decide)
