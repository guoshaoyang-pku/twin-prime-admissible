import Sound
import lean_certs.cert_29_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_92_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 29) (d := 92) (c := cert_29_92) (by decide)
