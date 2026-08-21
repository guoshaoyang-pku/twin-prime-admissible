import Sound
import lean_certs.cert_29_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_94_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 29) (d := 94) (c := cert_29_94) (by decide)
