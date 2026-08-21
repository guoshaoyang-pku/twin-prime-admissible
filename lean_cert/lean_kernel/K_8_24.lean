import Sound
import lean_certs.cert_8_24

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H8_gt_24_kernel : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 8) (d := 24) (c := cert_8_24) (by decide)
