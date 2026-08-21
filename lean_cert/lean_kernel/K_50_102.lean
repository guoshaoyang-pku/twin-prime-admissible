import Sound
import lean_certs.cert_50_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_102_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 50) (d := 102) (c := cert_50_102) (by decide)
