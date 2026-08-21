import Sound
import lean_certs.cert_25_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_102_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 25) (d := 102) (c := cert_25_102) (by decide)
