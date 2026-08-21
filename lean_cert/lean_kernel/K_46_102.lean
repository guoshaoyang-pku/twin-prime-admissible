import Sound
import lean_certs.cert_46_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_102_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 46) (d := 102) (c := cert_46_102) (by decide)
