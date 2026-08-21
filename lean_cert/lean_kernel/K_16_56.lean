import Sound
import lean_certs.cert_16_56

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_56_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 16) (d := 56) (c := cert_16_56) (by decide)
