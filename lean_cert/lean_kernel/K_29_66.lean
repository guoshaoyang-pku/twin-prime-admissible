import Sound
import lean_certs.cert_29_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_66_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 29) (d := 66) (c := cert_29_66) (by decide)
