import Sound
import lean_certs.cert_16_42

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_42_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 16) (d := 42) (c := cert_16_42) (by decide)
