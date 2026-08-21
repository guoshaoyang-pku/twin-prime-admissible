import Sound
import lean_certs.cert_26_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_102_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 26) (d := 102) (c := cert_26_102) (by decide)
