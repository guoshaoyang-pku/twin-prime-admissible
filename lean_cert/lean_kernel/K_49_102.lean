import Sound
import lean_certs.cert_49_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_102_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 49) (d := 102) (c := cert_49_102) (by decide)
