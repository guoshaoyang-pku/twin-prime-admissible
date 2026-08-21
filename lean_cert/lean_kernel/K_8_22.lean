import Sound
import lean_certs.cert_8_22

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H8_gt_22_kernel : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 8) (d := 22) (c := cert_8_22) (by decide)
