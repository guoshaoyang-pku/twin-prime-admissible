import Sound
import lean_certs.cert_28_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_102_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 28) (d := 102) (c := cert_28_102) (by decide)
