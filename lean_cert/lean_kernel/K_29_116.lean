import Sound
import lean_certs.cert_29_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_116_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 29) (d := 116) (c := cert_29_116) (by decide)
