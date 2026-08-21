import Sound
import lean_certs.cert_16_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_36_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 16) (d := 36) (c := cert_16_36) (by decide)
