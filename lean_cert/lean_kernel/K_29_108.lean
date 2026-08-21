import Sound
import lean_certs.cert_29_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_108_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 29) (d := 108) (c := cert_29_108) (by decide)
