import Sound
import lean_certs.cert_8_16

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H8_gt_16_kernel : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 16 := by
  exact certValidRoot_sound (k := 8) (d := 16) (c := cert_8_16) (by decide)
