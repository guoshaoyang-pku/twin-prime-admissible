import Sound
import lean_certs.cert_34_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_102_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 34) (d := 102) (c := cert_34_102) (by decide)
