import Sound
import lean_certs.cert_29_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_80_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 29) (d := 80) (c := cert_29_80) (by decide)
