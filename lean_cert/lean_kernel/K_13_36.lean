import Sound
import lean_certs.cert_13_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H13_gt_36_kernel : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 13) (d := 36) (c := cert_13_36) (by decide)
