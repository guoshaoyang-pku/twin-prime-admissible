import Sound
import lean_certs.cert_29_56

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_56_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 29) (d := 56) (c := cert_29_56) (by decide)
