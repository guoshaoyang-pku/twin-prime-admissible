import Sound
import lean_certs.cert_29_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_58_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 29) (d := 58) (c := cert_29_58) (by decide)
