import Sound
import lean_certs.cert_29_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_72_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 29) (d := 72) (c := cert_29_72) (by decide)
