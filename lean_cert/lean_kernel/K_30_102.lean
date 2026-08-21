import Sound
import lean_certs.cert_30_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_102_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 30) (d := 102) (c := cert_30_102) (by decide)
