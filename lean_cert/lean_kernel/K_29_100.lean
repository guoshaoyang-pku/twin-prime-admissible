import Sound
import lean_certs.cert_29_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_100_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 29) (d := 100) (c := cert_29_100) (by decide)
