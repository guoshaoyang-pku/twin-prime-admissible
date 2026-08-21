import Sound
import lean_certs.cert_48_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_102_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 48) (d := 102) (c := cert_48_102) (by decide)
